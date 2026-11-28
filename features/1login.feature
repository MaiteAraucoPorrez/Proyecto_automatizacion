@login @maximize
Feature: SauceDemo Login
  In order to buy products on SauceDemo
  As a customer
  I want to log in with my credentials

  Scenario: Login successfully with a standard user
    Given I am on the SauceDemo login page
    When I log in with user "standard_user" and password "secret_sauce"
    Then I should see the products page

  Scenario: Login with a locked out user
    Given I am on the SauceDemo login page
    When I log in with user "locked_out_user" and password "secret_sauce"
    Then I should see the error "Epic sadface: Sorry, this user has been locked out."

  Scenario Outline: Login with invalid credentials
    Given I am on the SauceDemo login page
    When I log in with user "<user>" and password "<password>"
    Then I should see the error "<error>"

    Examples:
      | user          | password     | error                                                                     |
      | standard_user | wrong_pass   | Epic sadface: Username and password do not match any user in this service |
      | invalid_user  | secret_sauce | Epic sadface: Username and password do not match any user in this service |
      |               | secret_sauce | Epic sadface: Username is required                                        |
      | standard_user |              | Epic sadface: Password is required                                        |

  Scenario: Products page cannot be accessed without logging in
    Given I am on the SauceDemo login page
    When I open the page "/inventory.html" directly
    Then the error message contains "when you are logged in"
