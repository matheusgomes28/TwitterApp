require 'sqlite3'

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

  # Sending results to the page
  puts user_details.length

  @username = session[:username]
  @password = '*'*user_details[0][0].length
  @email = user_details[0][1]
  @twitter = user_details[0][2]
  @c_key = user_details[0][3]
  @c_secret = user_details[0][4]
  @access_token = user_details[0][5]
  @access_token_s = user_details[0][6]

  @title = 'My Settings'
  erb :settings
end