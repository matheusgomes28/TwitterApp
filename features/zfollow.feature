Feature:

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



