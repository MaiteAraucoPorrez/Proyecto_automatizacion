@logout
Feature: SauceDemo Logout
  In order to protect my account
  As a logged in customer
  I want to log out of the application

  Background:
    Given I am logged in as a standard user

  Scenario: Logout from the products page
    When I log out
    Then I should be back on the login page

  Scenario: Products page cannot be accessed after logging out
    When I log out
    And I open the page "/inventory.html" directly
    Then the error message contains "when you are logged in"
