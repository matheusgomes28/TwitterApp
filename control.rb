require 'twitter'
require 'sqlite3'
require 'digest'
require 'thin'
require 'sinatra'
include ERB::Util

#Enable sessions for login system
enable :sessions
set :session_secret, 'team09init'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #Fix SSL problem

before do

  # Initialize database, client and md5 digester
  @db = SQLite3::Database.new('login.db')

  @md5 = Digest::MD5.new

  if session[:logged_in] then

    # Get user's tokens from db
    user_details = @db.execute %{
                                   SELECT settings.consumer_key,
                                          settings.consumer_secret,
                                          settings.access_token,
                                          settings.access_token_secret
                                   FROM users, settings
                                   WHERE users.username = '#{session[:username]}' AND users.username = settings.username;
                                  }

    config = {
        :consumer_key => user_details[0][0],
        :consumer_secret => user_details[0][1],
        :access_token => user_details[0][2],
        :access_token_secret => user_details[0][3],
    }

    # Create client
    @client = Twitter::REST::Client.new(config)

  end

end


get '/logout' do
  session.clear

  erb :logout
end

# The main page
get '/' do

  # Redirect user if logged in
  redirect '/search' unless !session[:logged_in]

  erb :index # Else show login
end


# The register page
get '/register' do
  erb :register
end


# The validation page...
post '/validate' do

  if !is_valid_username(params[:username]) then

    # Get the unique*** password hash from the db
    password = @db.execute("SELECT password FROM users WHERE username='#{params[:username]}'")[0][0]

    # Compares both hashes to see if password is the same
    if password == @md5.hexdigest(params[:password]).to_s then

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

# The search page
get '/search' do
  erb :tweet_search
end

get '/do_search' do

  #protect page
  redirect '/' unless session[:logged_in]

  # Get a tweet list containing recent search results
  @search_list = @client.search(params[:search]).take(10)
  erb :show_tweets
end

# The register validation
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

post '/campaign' do

  query = 'INSERT INTO campaigns(name, desc, keyword, username) VALUES(?, ?, ?, ?)'

  # Execute strings and prepare query
  @db.execute(query, [params[:name], params[:desc], params[:keyword], session[:username]])

  # redirect user to campaign page
  @submitted = true
  erb :campaigns
end

get '/campaign' do
  erb :campaigns
end

get '/show_campaigns' do

  puts params[:order]
  #simple select
  query = 'SELECT name, desc, keyword FROM campaigns'
  if params[:order] != nil then
    query += " ORDER BY ? ;"
  else
    query += ';'
  end

  # Send user and campaign results to show_campaigns page FIXXXX
  @camps = @db.execute(query, params[:order])

  erb :show_campaigns
end

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

  erb :settings
end

get '/messages' do

  # Get direct messages from the client
  @direct_messages = @client.direct_messages

  erb :direct_messages
end

def is_valid_username(username)

  db = SQLite3::Database.new 'login.db'

  # if value is returned then username is not valid
  if db.execute("SELECT 1 FROM users WHERE username='#{username}'").length > 0 then

    return false

  else
    return true
  end
end

def is_email_taken(email)

  db = SQLite3::Database.new 'login.db'

  if db.execute("SELECT 1 FROM users WHERE email='#{email}'").length  > 0 then
    return true

  else
    return false
  end
end
