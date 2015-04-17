# This file contains all the validation code
# needed for user login, registration and
# other parts of the system that may require
# user inputs and validation.

require 'sqlite3'
require 'digest'

require_relative('useful_functions')

# The validation page...
post '/login_validate' do

  if !is_valid_username(params[:username]) then

    # Get the unique*** password hash from the db
    password = @db.execute("SELECT password FROM users WHERE username='#{params[:username]}'")[0][0]

    # Compares both hashes to see if password is the same
    if password == @md5.hexdigest(params[:password]) then

      session[:logged_in] = true
      session[:username] = params[:username]

      # Sends to access granted page and creates session

      redirect '/search'

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
    if is_valid_username(params[:username]) then

      if !is_email_taken(params[:email]) then
        passDigest = @md5.hexdigest(params[:password])

        # Insert user details into database
        query = %{BEGIN;
                  INSERT INTO users(username, password, email, twitter) VALUES('#{params[:username]}','#{passDigest}', '#{params[:email]}','#{params[:twitter]}');
                  INSERT INTO settings(username, consumer_key, consumer_secret, access_token, access_token_secret) VALUES('#{params[:username]}','#{params[:consumer_key]}', '#{params[:consumer_secret]}','#{params[:access_token]}', '#{params[:access_token_secret]}');
                  END;
                }

        @db.execute_batch query
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
    @error = "Password don't match"
    erb :wrong_info
  end
end
