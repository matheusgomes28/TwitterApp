Feature: Automatic follow/unfollowing someone
  As a user,
  I want the system to automatically follow/unfollow people,
  So that I can contact relevant people

  Scenario: Go to the campaign stat page
    Given I am logged in
    When I follow "View Campaigns" within "header"
    When I follow "Just A Ruby Test" within "div[id='show_table']"
    Then I should see "Campaign Statistics Page"

  Scenario: Automatically follow
    Given I am logged in
    When I follow "View Campaigns" within "header"
    When I follow "Just A Ruby Test" within "div[id='show_table']"
    When I press "Automatically Follow" within "form[name='automatic_follow']"
    Then I should see "Users followed:"


  Scenario: Automatically unfollow
    Given I am logged in
    When I follow "Friends" within "header"
    When I press "Unfollow Automatically" within "form[name='automatic_unfollow']"
    Then I should see "Users unfollowed:"
