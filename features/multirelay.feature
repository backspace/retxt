Feature: Multi-relay

  Scenario: Relay a txt on one relay
    Given I am subscribed to relay A as 'alice'
    And someone is subscribed to relay A as 'bob'

    Given I am subscribed to relay B
    And someone is subscribed to relay B as 'colleen'

    When I txt 'this message should not go to everyone' to relay A
    Then I should receive a confirmation txt
    And bob should receive '@alice sez: this message should not go to everyone'
    And colleen should not receive a message
