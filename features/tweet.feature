Feature: Testing twitter features
  As a user,
  I want to be able to perform common twitter tasks,
  So that I can completely rely on the system.

  Scenario: Testing the tweet feature within homepage
    Given I am logged in
    Given I am on the homepage
    When I fill in "tweet" with "A simple tweet test" within "form[name='tweet']"
    When I press "Tweet" within "form[name='tweet']"
    Then I should see "Your message has been tweeted"
