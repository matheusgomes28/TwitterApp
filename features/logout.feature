Feature: Testing the logout mechanism
  As a user,
  I want to be able to logout of the system
  So that I am the only one accessing my account


  Scenario: Logging out of the system using the logout link
    Given I am logged in
    When I follow "Logout" within "header"
    Then I should see "You have been successfully logged out!"
