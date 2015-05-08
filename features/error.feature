Feature: Testing for the contact given in case of an error

  Scenario: Test for the error message
    Given I am logged in
    When I go to the error page
    Then I should see "404 - page not found"