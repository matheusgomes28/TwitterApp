Feature: Test the search history mechanism of the system
  As I user,
  I want to be able to save some of my search strings,
  So that I can revisit some of my searches


  Scenario: Save search to search history
    Given I am logged in
    Given I am on the homepage
    When I fill in "search" with "ruby is fun" within "form[id='search']"
    When I check "save_search" within "form[id='search']"
    When I press "Search" within "form[id='search']"
    Then I should see "Search string was saved!"


  Scenario: View all my search history
    Given I am logged in
    Given I am on the search history page
    Then I should see "ruby is fun"