@carrito @maximize
Feature: SauceDemo Shopping Cart
  In order to buy products
  As a logged in customer
  I want to manage the products in my cart

  Background:
    Given I am logged in as a standard user

  Scenario: Add one product to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    Then the cart badge shows 1 item
    When I open the cart
    Then the cart contains the following products:
      | Sauce Labs Backpack |

  Scenario: Add several products to the cart
    When I add the product "Sauce Labs Backpack" to the cart
    And I add the product "Sauce Labs Bike Light" to the cart
    Then the cart badge shows 2 items
    When I open the cart
    Then the cart contains the following products:
      | Sauce Labs Backpack   |
      | Sauce Labs Bike Light |

  Scenario Outline: Each product is shown in the cart with its price
    When I add the product "<product>" to the cart
    And I open the cart
    Then the cart shows the product "<product>" with the price defined for it

    Examples:
      | product                           |
      | Sauce Labs Backpack               |
      | Sauce Labs Bike Light             |
      | Sauce Labs Bolt T-Shirt           |
      | Sauce Labs Fleece Jacket          |
      | Sauce Labs Onesie                 |
      | Test.allTheThings() T-Shirt (Red) |

  Scenario: Remove a product from the cart
    Given I add the products "Sauce Labs Backpack; Sauce Labs Bike Light" to the cart
    When I open the cart
    And I remove the product "Sauce Labs Backpack" from the cart
    Then the cart contains the following products:
      | Sauce Labs Bike Light |
    And the cart badge shows 1 item

  Scenario: Remove the only product from the products page
    Given I add the product "Sauce Labs Onesie" to the cart
    When I remove the product "Sauce Labs Onesie" from the cart
    Then the cart badge is not displayed
