Feature: Clear

  Scenario: An admin clears a relay
    Given I am signed in as an admin
    And someone is subscribed to relay A as 'alice'
    And I am subscribed to relay A as an admin

    When I txt '/clear' to relay A
    And I visit the subscribers list
    Then I should not see that 'alice' is subscribed to relay A
    But I should see that I am subscribed to relay A
