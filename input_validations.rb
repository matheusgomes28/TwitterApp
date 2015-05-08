# This file contains all the validation code
# needed for user login, registration and
# other parts of the system that may require
# user inputs and validation.


require 'sqlite3'
require 'digest'
require 'date'

require_relative('useful_functions')

# The validation page...
post '/login_validate' do

  if !is_valid_username(@db, params[:username]) then

    # Get the unique*** password hash from the db
    password = @db.execute('SELECT password FROM users WHERE username=?', [params[:username]])[0][0]

    # Compares both hashes to see if password is the same
    if password == @md5.hexdigest(params[:password]) then

      # Set sessions needed
      session[:logged_in] = true
      session[:username] = params[:username]

      # Add login time session to db
      query = "INSERT INTO sessions(username, date) VALUES(?, DATETIME(?, 'localtime'))"
      @db.execute(query, [session[:username], DateTime.now.to_s])
      puts 'executed login'

      # Sends to access granted page and creates session
      redirect '/home'

    else

      # Sends to access denied page
      erb :accessDenied

    end

  else
    @error = 'Not a valid username'
    erb :wrong_info
  end

end


# The registration validation
post '/register_validate' do

  if params[:cPassword] == params[:password] then

    # Check is username is valid
    if is_valid_username(@db, params[:username]) then

      if !is_email_taken(@db, params[:email]) then
        passDigest = @md5.hexdigest(params[:password])


        # Execute multiple statements within transaction
        @db.execute 'BEGIN;'
        query = 'INSERT INTO users(username, password, email, twitter) VALUES(?,?,?,?);'
        @db.execute(query, [params[:username], passDigest, params[:email], params[:twitter]])
        query = 'INSERT INTO settings(username, consumer_key, consumer_secret, access_token, access_token_secret)'
        query << 'VALUES(?,?,?,?,?);'
        @db.execute(query, [params[:username], params[:consumer_key], params[:consumer_secret],
                            params[:access_token], params[:access_token_secret]])
        @db.execute 'END;'

        erb :accessGranted

      else
        @error = 'Email already registered'
        erb :wrong_info
      end

    else
      # Sends out error message to be displayed
      @error = 'Username already taken'
      erb :wrong_info
    end

  else # Error string returned
    @error = "Passwords don't match"
    erb :wrong_info
  end
end
