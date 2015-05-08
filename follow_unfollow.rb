require_relative('follower_candidate')


WHITE_LIST_SCORE = 11
BLACK_LIST_SCORE = 6

get '/automatic_follow' do

  followed = 0 # Holds users followed.

  # Take 10 most recent tweets
  search_list = @client.search('#'+params[:keyword]).take(10)

  # Examine each ecent tweet for new followers
  search_list.each do |tweet|

    tweet_user = tweet.user

    # Create a possible new follower and init score
    candidate = FollowerCandidate.new(@client, tweet_user, tweet)
    score = candidate.calculate_score

    # Follows if candidate fills criteria
    if score > WHITE_LIST_SCORE then
      @client.follow(tweet_user)
      followed += 1
    end

  end


  # Redirect back to campaign page
  redirect "/campaign_stat?id=#{params[:id]}&followed=#{followed}"
end


# This is where the code for the
# unfollow page goes.
get '/show_friends' do

  first_follower = params[:last_id]

  puts first_follower == nil

  @friends = first_follower == nil ? @client.friends.take(10) : @client.friends(:max_id => first_follower).take(10)

  @friends.each do |user|
    puts user.id
  end
  erb :show_friends
end


# Gt block fo the automatic
# unfollow feature of the
# system
get '/automatic_unfollow' do

  unfollowed = 0 # Number of users unfollowed

  # Get array of 10 recent friends
  friends = @client.friends.take(10)

  friends.each do |user|

    # Get FollowerCandidate obj to calculate score
    candidate = FollowerCandidate.new(@client, user, nil)
    score = candidate.calculate_score

    # Unfollow if score is less than expected
    if score <= BLACK_LIST_SCORE then
      @client.unfollow(user)
      unfollowed += 1
    end
  end

  # Show the friends againw
  redirect "/show_friends?unfollowed=#{unfollowed}"

end