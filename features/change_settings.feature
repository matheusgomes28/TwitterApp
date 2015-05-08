Feature: Testig the ability to change settings
  As a user,
  I want to be able to change my settings,
  So that I can update keys or details if they change.

  Scenario: Changing the settings with correct details
    Given I am logged in
    When I follow "Settings" within "nav"
    When I fill in "oldPassword" with "password" within "form"
    When I fill in "newPassword" with "password" within "form"
    When I fill in "email" with "Random@sheffield.ac.uk" within "form"
    When I fill in "twitter" with "mattgomes28" within "form"
    When I fill in "consumer_key" with "YOUR KEY" within "form"
    When I fill in "consumer_secret" with "YOUR KEY" within "form"
    When I fill in "access_token" with "YOUR KEY" within "form"
    When I fill in "access_token_secret" with "YOUR KEY" within "form"
    When I press "Submit" within "form"
    Then I should see "Successfully changed your details!"

  Scenario: Changing settings with wrong details (password)
    Given I am logged in
    When I follow "Settings" within "nav"
    When I fill in "oldPassword" with "nonsense" within "form"
    When I fill in "newPassword" with "password" within "form"
    When I fill in "email" with "mdeaguiargomes1@sheffield.ac.uk" within "form"
    When I fill in "twitter" with "mattgomes28" within "form"
    When I fill in "consumer_key" with "YOUR KEY" within "form"
    When I fill in "consumer_secret" with "YOUR KEY" within "form"
    When I fill in "access_token" with "YOUR KEY" within "form"
    When I fill in "access_token_secret" with "YOUR KEY" within "form"
    When I press "Submit" within "form"
    Then I should see "Wrong inputs entered, errors:"

  # ADD YOUR OWN KEYS OTHERWISE TESTING WONT WORK
  Scenario: Changing settings back for things to work
    Given I am logged in
    When I follow "Settings" within "nav"
    When I fill in "oldPassword" with "password" within "form"
    When I fill in "newPassword" with "password" within "form"
    When I fill in "email" with "mdeaguiargomes1@sheffield.ac.uk" within "form"
    When I fill in "twitter" with "mattgomes28" within "form"
    When I fill in "consumer_key" with "EDIT THIS" within "form"
    When I fill in "consumer_secret" with "EDIT THIS" within "form"
    When I fill in "access_token" with "EDIT THIS" within "form"
    When I fill in "access_token_secret" with "EDIT THIS" within "form"
    When I press "Submit" within "form"
    Then I should see "Successfully changed your details!"