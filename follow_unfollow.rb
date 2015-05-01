require_relative('follower_candidate')


WHITE_LIST_SCORE = 11

get '/automatic_follow' do

  # Take 10 most recent tweets
  search_list = @client.search('#'+params[:keyword]).take(10)

  # Examine each ecent tweet for new followers
  search_list.each do |tweet|

    # Create a possible new follower and init score
    candidate = FollowerCandidate.new(@client, tweet.user, tweet)
    score = 0

    # Extra points for profile pic
    if candidate.has_picture? then
      score += 5
    end

    score += (5 - candidate.last_active) # score for being active
    score += candidate.campaign_score  # Calculate score on certain camp


    # Follows if candidate fills criteria
    if score > WHITE_LIST_SCORE then
      puts 'Followed +1'
      @client.follow(tweet.user)
    end

  end

  # Redirect back to campaign page
  redirect "/campaign_stat?id=#{params[:id]}"
end