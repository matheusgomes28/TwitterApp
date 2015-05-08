Feature: Testing the "registering new accounts" feature of the system.
  As a user,
  I want to be able to register my own account on the system,
  So that I can carry out tasks that the system offers to users


  Scenario: Registering with correct details
    Given I am on the register page
    When I fill in "username" with "user" within "form"
    When I fill in "password" with "secret" within "form"
    When I fill in "cPassword" with "secret" within "form"
    When I fill in "email" with "email@example.com" within "form"
    When I fill in "twitter" with "twitterAccount" within "form"
    When I fill in "consumer_key" with "EDIT THIS" within "form"
    When I fill in "consumer_secret" with "EDIT THIS" within "form"
    When I fill in "access_token" with "EDIT THIS" within "form"
    When I fill in "access_token_secret" with "EDIT THIS" within "form"
    When I press "Submit" within "form"
    Then I should see "Access granted"


  Scenario: Logging in with the newly create account
    Given I am on the homepage
    When I fill in "username" with "user" within "form"
    When I fill in "password" with "secret" within "form"
    When I press "Submit" within "form"
    Then I should see "Welcome back!"