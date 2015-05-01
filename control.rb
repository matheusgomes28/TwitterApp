require 'twitter'
require 'sqlite3'
require 'digest'
require 'thin'
require 'sinatra'
include ERB::Util

require_relative('directions')
require_relative('user_settings')
require_relative('input_validations')
require_relative('follow_unfollow')

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

