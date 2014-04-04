Feature: Users

  Scenario: List users
    Given 'user@example.com' is registered
    And I am signed in as an admin

    When I visit the users list
    Then I should see that 'user@example.com' is registered
    And I should see that 'admin@example.com' is registered

  @javascript
  Scenario: Make a user an admin
    Given 'user@example.com' is registered
    And I am signed in as an admin

    When I make 'user@example.com' an admin
    And I visit the users list
    Then I should see that 'user@example.com' is a site admin
