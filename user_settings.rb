require 'sqlite3'
require_relative('useful_functions')


get '/settings' do

  # Only accessible to users
  redirect '/' unless session[:logged_in]

  # Gettings results from linked tables
  user_details = @db.execute(%{
                               SELECT users.password, users.email, users.twitter, settings.consumer_key,
                               settings.consumer_secret, settings.access_token, settings.access_token_secret
                               FROM users, settings
                               WHERE users.username = ? AND users.username = settings.username;
                              },
                             session[:username])

  # Send results to settings page
  @username = session[:username]
  @password_hash = user_details[0][0]
  @email = user_details[0][1]
  @twitter = user_details[0][2]
  @c_key = user_details[0][3]
  @c_secret = user_details[0][4]
  @access_token = user_details[0][5]
  @access_token_s = user_details[0][6]

  @title = 'My Settings'
  erb :settings
end


# Validate the request to change settings
post '/settings_validate' do

  # Tell if procedure has been successful
  @success = false


  # Defining values for readability purposes
  current_password = @db.execute('SELECT password FROM users WHERE username = ?', [session[:username]])[0][0]
  oldPassword_hash = @md5.hexdigest(params[:oldPassword])
  newPassword_hash = @md5.hexdigest(params[:newPassword])
  newEmail = params[:email].strip
  newTwitter = params[:twitter].strip
  newConsumer_key = params[:consumer_key].strip
  newConsumer_secret = params[:consumer_secret].strip
  newAccess_token = params[:access_token].strip
  newAccess_secret = params[:access_token_secret].strip


  @errors = ''

  # Check if user typed right password
  if oldPassword_hash != current_password then
    @errors << 'Wrong current password;'
  end
  if is_email_taken(@db, newEmail) then
    @errors << 'Email is taken;'
  end
  if newEmail == '' || newTwitter == '' || newConsumer_key == '' ||
     newConsumer_secret == '' || newAccess_token == '' ||
     newAccess_secret == '' then
    @errors << "Fields can't be left blank."
  end

  # Doesn't proceed if there are errors
  if @errors != '' then
    erb :settings

  else
    # Execute more than one query bcus exeute_batch not working for UPDATE
    query = 'UPDATE users SET password=?, email=?, twitter=? WHERE username=?;'
    @db.execute(query, [newPassword_hash, newEmail, newTwitter, session[:username]])
    query = 'UPDATE settings SET consumer_key=?, consumer_secret=?, access_token=?, access_token_secret=? WHERE username=?'
    @db.execute(query, [newConsumer_key, newConsumer_secret, newAccess_token,
                        newAccess_secret, session[:username]])

    @success = true
    erb :settings #Send back to settings page
  end

end