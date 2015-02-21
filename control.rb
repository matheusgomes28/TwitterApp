require 'twitter'
require 'sqlite3'
require 'digest'
require 'thin'
require 'sinatra'


# The main page
get '/' do
  erb :index
end


# The register page
get '/register' do
  erb :register
end


# The validation page...
post '/validate' do

  # Initialize database and md5 digester
  db = SQLite3::Database.new 'login.db'
  md5 = Digest::MD5.new


  if !is_valid_username(params[:username]) then

    # Get the unique*** password hash from the db
    password = db.execute("SELECT password FROM users WHERE username='#{params[:username]}'")[0][0]

    # Compares both hashes to see if password is the same
    if password == md5.hexdigest(params[:password]).to_s then

      # Sends to access granted page
      erb :accessGranted

    else

      # Sends to access denied page
      erb :accessDenied

    end

  else
    @error = 'Not a valid username'
    erb :wrong_info
  end

end


# The register validation
post '/register_validate' do

  if params[:cPassword] == params[:password] then

    # Check is username is valid
    if is_valid_username(params[:username]) then

      # Create new db connection
      db = SQLite3::Database.new 'login.db'

      passDigest = Digest::MD5.hexdigest(params[:password])

      # Insert user details into database
      db.execute "INSERT INTO users(username, password) VALUES('#{params[:username]}','#{passDigest}')"
      erb :accessGranted

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

def is_valid_username(username)

  db = SQLite3::Database.new 'login.db'

  # if value is returned then username is not valid
  if db.execute("SELECT 1 FROM users WHERE username='#{username}'").length > 0 then

    return false

  else
    return true
  end
end
