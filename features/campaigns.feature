Feature: Testing all the campaign-related features
  As a user/admin,
  I want to be able to create/view/delete campaigns
  So that I can..... EDIT*** CANT REMEMBER THE USER STORY

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
