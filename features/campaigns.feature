Feature: Testing all the campaign-related features

  As a user/admin,
  I want to be able to create/view/delete campaigns
  So that I can maintain the campaigns.

  Scenario: Creating a new campaign (edit values if needed)
    Given I am logged in
    Given I am on the create campaigns page
    When I fill in "name" with "Campaign Test" within "form"
    When I fill in "desc" with "Campaign Description" within "form"
    When I fill in "keyword" with "#SoftwareEngineering" within "form"
    When I press "Submit" within "form"
    Then I should see "Campaign (Campaign Test) was submitted successfully!"


  Scenario: View campaigns that have been previously created
    Given I am logged in
    Given I am on the view campaigns page
    Then I should see "Campaign Test"
    Then I should see "Campaign Description"
    Then I should see "#SoftwareEngineering"


  Scenario: Deleting a campaign from the system
    Given I am logged in
    Given I am on the view campaigns page
    When I press "Submit" within "form[name='CampaignTest']"
    Then I should not see "Campaign Test" within "table"
    Then I should not see "Campaign Description" within "table"
    Then I should not see "#SoftwareEngineering" within "table"


  Scenario: Sorting campaigns retweets by number of retweets
    Given I am logged in
    Given I am on the view campaigns page
    When I follow "rubymine" within "table"
    When I follow "Retweets▼" within "table[id='tweet-table']"
    Then I should not see "Internal server error"


  Scenario: Sorting campaigns retweets by number of favourites
    Given I am logged in
    Given I am on the view campaigns page
    When I follow "rubymine" within "table"
    When I follow "Favourites▼" within "table[id='tweet-table']"
    Then I should not see "Internal server error"