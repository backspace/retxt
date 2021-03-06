Feature: Rename

  Scenario: An admin renames a relay
    Given I am signed in as an admin

    And someone is subscribed to relay A as Alice
    And I am subscribed to relay A as an admin

    When I txt '/rename X' to relay A
    Then I should receive a txt that anon renamed the relay to X
    And I visit the subscribers list
    Then I should see that Alice is subscribed to relay X
