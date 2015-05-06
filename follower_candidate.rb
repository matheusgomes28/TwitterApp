# Class made for calculating
# a user score to people that
# are involved with a campaign.
# WRITTEN BY: Matt Gomeszzzzzzzzzz xx

require 'twitter' #Needed for the user and tweet objects

class FollowerCandidate

  # Criteria value for retweets and favorites
  FAVORITE_SCORE = 1
  RETWEET_SCORE = 3

  def initialize(rest_client, twitter_user, campaign_tweet)
    @client = rest_client
    @candidate = twitter_user
    @camp_tweet  = campaign_tweet
  end


  # This methods simply checks if
  # the user has a profile picture
  # to be used in the user score
  def has_picture?

    # Update if twitter updates the default urls
    check_directories  = ['default_profile_images']

    # Get info from user's profile image
    image_url = @candidate.profile_image_uri.to_s
    dir_list = image_url.split('/')

    # Simple if else to check if image is contained
    # in the default directory => no profile img
    check_directories.each do |dir|
      if dir_list.include? dir then
        return true
      end
    end
  end



  # This method checks the activity
  # of a twitter user and returns
  # the time (in days) that he/she
  # was last active.
  def last_active

    # Getting last tweet off user timeline
    last_tweet = @client.user_timeline(@candidate).take(1)[0]

    # Using Time class to get the difference in seconds then days
    days_inactive = (Time.now - last_tweet.created_at) / 86400

    puts @candidate.screen_name
    puts days_inactive.floor

    return days_inactive.floor #  Return # of days inactive

  end


  # This method will calculate the
  # user score related to the a
  # certain campaign that the user retweeted
  def campaign_score

    final_score = 0 # Starts with no score

    # Calculate the points gained from campaign
    if @camp_tweet != nil then
      final_score += @camp_tweet.favorite_count*FAVORITE_SCORE
      final_score += @camp_tweet.retweet_count*RETWEET_SCORE
    end

    return final_score
  end


  # This methods calculates the overall
  # score for following or unfollowing
  # a user.
  def calculate_score

    # Default score
    score = 0

    # Extra points for picture
    if has_picture? then
      score += 5
    end

    score += (5 - last_active) # score for being active
    score += campaign_score  # Calculate score on certain camp


    return score
  end


end