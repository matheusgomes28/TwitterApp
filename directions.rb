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
  session.clear #Clear data in session
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
  @title = 'TweetCamp - Home page'
  erb :home
end


get '/do_search' do

  #protect page
  redirect '/' unless session[:logged_in]

  # Get a tweet list containing recent search results
  @search_list = @client.search(params[:search]).take(10)

  # Save the search if user requested so
  if params[:save_search] == 'on' then
    query = 'INSERT INTO searches(username, search) VALUES(?, ?);'
    @db.execute(query, [session[:username], params[:search]])
  end

  @title = 'Showing search results'
  erb :show_tweets
end

# When a campaign is being created
post '/campaign' do

  query = 'INSERT INTO campaigns(id, name, desc, keyword, username) VALUES(?, ?, ?, ?, ?)'
  tweet = @client.update params[:desc]+' '+params[:keyword] # Tweet camp

  # Execute strings and prepare query
  @db.execute(query, [tweet.id, params[:name], params[:desc], params[:keyword], session[:username]])

  # redirect user to campaign page
  @submitted = true
  @title = 'Creating a campaign'
  erb :campaigns
end


get '/show_campaigns' do

  # Initial query
  query = 'SELECT name, desc, keyword, id FROM campaigns'

  # Select case for defining the order
  case params[:order]
    when 'name'
      query << ' ORDER BY name;'
    when 'desc'
      query << ' ORDER BY desc;'
    when 'keyword'
      query << ' ORDER BY keyword;'
    else
      query << ';'
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

  # Query for deleting a campaign when button clicked
  query = 'DELETE FROM campaigns WHERE id = ?';
  @db.execute(query, params[:campaign_id])

  redirect '/show_campaigns' #Go to get page
end

get '/campaign_stat' do

  #protect page
  redirect '/' unless session[:logged_in]

  #Query to get campaign info
  query = 'SELECT name, desc, keyword FROM campaigns WHERE id = ?'
  @campaign = @db.execute(query, [params[:id]])

  # Get a tweet list containing search results
  @search_list = @client.search(@campaign[0][2]).take(10)

  # Get the tweet sent out when making the campaign
  @tweet = @client.status(params[:id])

  @title = @campaign[0][0]
  erb :campaign_stat
end

get '/show-history' do

  query = 'SELECT search FROM searches WHERE username = ?';
  @searches = @db.execute(query, session[:username])
  erb :show_history
  
end





# The following three gets are used to display
# the correct button (follow/unfollow) in
# pages where it's possible to follow other
# users - using iframes instead of AJAX because
# we haven't learnt it yet ;)

get '/show_button' do

  # Get info from parameters
  @followed = params[:followed]
  @height = params[:height]
  @width = params[:width]
  @twitter_name = params[:user]

  erb :show_button

end

get '/follow' do
  @client.follow(params[:user])
  redirect "/show_button?user=#{params[:user]}&followed=1&height=30&width=70"
end

get '/unfollow' do

  @client.unfollow(params[:user])
  redirect "/show_button?user=#{params[:user]}&followed=0&height=30&width=70"

end


not_found do
  @title = 'Page not found'
  @error = '404 - page not found'
  erb :not_found
end

error do
  @title = 'Internal server error'
  @error = 'Internal server error'
  erb :not_found
end
