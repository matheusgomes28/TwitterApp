# This file contains the code needed
# to display the right webpages and
# code to the user. This is mostly
# done by using the the get function.

require('sqlite3')
require('twitter')

# The main page
get '/' do

  # Redirect user if logged in
  redirect '/home' unless !session[:logged_in]

  @title = 'TweetCamp - Log in'
  erb :index # Else show login
end

get '/logout' do
  session.clear
  @title = 'Logged out!'
  erb :logout
end

# The register page
get '/register' do
  @title = 'Register with us!'
  erb :register
end

# The search page
get '/home' do
  @title = 'Search page'
  erb :home
end

get '/do_search' do

  #protect page
  redirect '/' unless session[:logged_in]

  # Get a tweet list containing recent search results
  @search_list = @client.search(params[:search]).take(10)

  puts params[:save_search]

  if params[:save_search] == 'on' then
    query = 'INSERT INTO searches(username, search) VALUES(?, ?);'
    @db.execute(query, [session[:username], params[:search]])
    puts 'saved search'
  end

  @title = 'Showing search results'
  erb :show_tweets
end

# When a campaign is being created
post '/campaign' do

  query = 'INSERT INTO campaigns(name, desc, keyword, username) VALUES(?, ?, ?, ?)'

  # Execute strings and prepare query
  @db.execute(query, [params[:name], params[:desc], params[:keyword], session[:username]])

  # redirect user to campaign page
  @submitted = true
  @title = 'Creating a campaign'
  erb :campaigns
end


get '/show_campaigns' do

  #simple select
  if params[:order] != nil then
    query = "SELECT name, desc, keyword, id FROM campaigns ORDER BY #{params[:order]}"
  else
    query = 'SELECT name, desc, keyword, id FROM campaigns'
  end

  # Send user and campaign results to show_campaigns page FIXXXX
  @camps = @db.execute(query)

  @title = 'Showing campaigns'
  erb :show_campaigns
end

get '/campaign' do
  @title = 'Create a campaign'
  erb :campaigns
end

post '/show_campaigns' do
  query = 'DELETE FROM campaigns WHERE id = ?';
  @db.execute(query, params[:id])
  erb :show_campaigns
end

get '/campaign_stat' do

  #simple select
  if params[:order] != nil then
    query = "SELECT name FROM campaigns ORDER BY #{params[:order]}"
  else
    query = 'SELECT name FROM campaigns'
  end

  # Send user and campaign results to show_campaigns page FIXXXX
  @camps = @db.execute(query)

  @title = 'Campaigns status'
  erb :campaign_stat
end

get '/show-history' do

  query = 'SELECT search FROM searches WHERE username = ?';
  @searches = @db.execute(query, session[:username])
  erb :show_history

end