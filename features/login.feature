# Scenarios go here!

Feature: login

  Scenario : Correct password entered
    Given I am on the home page not logged in
    When I fill in the username "<username>" with the correct "<username2>"
    When I fill in "<password>" with the correct "<password2>"
    And I press "Submit" within "form"
    Then I see the "<home_page>" logged in


  Scenario : Incorrect password entered
    Given I am on <page_name>
    When I fill in the username "<username>" with the correct "<username2>"
    When I fill in "<password>" with the wrong "<password2>"
    And I press "<button>" within "<selector>"
    Then I see the "<error_message>" "Access Denied"

  Scenario Outline: Incorrect username entered
    Given I am on <page_name>
    When I fill in the username "<username>" with the wrong "<username2>"
    When I fill in "<password>" with the wrong "<password2>"
    And I press "<button>" within "<selector>"
    Then I see the "<error_message>" "<argument>"
  Examples:
    | page_name   | password   | password2   | button   | selector   | error_message   | argument      |
    | <page_name> | <password> | <password2> | <button> | <selector> | <error_message> | Access Denied |

