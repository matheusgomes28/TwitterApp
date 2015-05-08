Feature: Testing the navigation of the app to make sure that everything works fine

  Scenario: Be able to navigate to settings
    Given I am logged in
    When I follow "Settings" within "header"
    Then I should see "Change your details."

  Scenario: Be able to navigate to search history
    Given I am logged in
    When I follow "Search History" within "header"
    Then I should see "Search History For:"

  Scenario: Be able to navigate to friends
    Given I am logged in
    When I follow "Friends" within "header"
    Then I should see "Friends - People I follow."

  Scenario: Be able to navigate to home
    Given I am logged in
    When I follow "Home" within "header"
    Then I should see " Welcome Back! Search for something..."

  Scenario: Be able to navigate to Create campaign
    Given I am logged in
    When I follow "Create Campaign" within "header"
    Then I should see "Create a new campaign!"

  Scenario: Be able to navigate to View campaigns
    Given I am logged in
    When I follow "View Campaigns" within "header"
    Then I should see "Campaigns created so far"






