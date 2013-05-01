Feature: Who

  Scenario: List who is subscribed to a relay
    Given I am subscribed to relay A as an admin as 'alice'

    And someone is subscribed to relay A as 'bob'
    And someone is subscribed to relay A as 'colleen'
    And someone is subscribed to relay A

    And someone is subscribed to relay B as 'dean'

    When I txt '/who' to relay A
    Then I should receive a txt including '@alice*'
    And I should receive a txt including '@bob'
    And I should receive a txt including '@colleen'
    And I should receive a txt including 'anon'
    But I should not receive a txt including '@dean'
