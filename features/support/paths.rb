module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
      when /the home\s?page/
        '/'

      # Page for creating a campaign
      when /the create campaign(s)? page/
        '/campaign'

      # view campaigns
      when /the view campaign(s)? page/
        '/show_campaigns'

      when /the search history page/
        '/show-history'

      when /the register page/
        '/register'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))


    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)
