Feature: Multi-relay

  Scenario: Relay a txt on one relay
    Given I am subscribed to relay A as Alice
    And someone is subscribed to relay A as Bob

    Given I am subscribed to relay B
    And someone is subscribed to relay B as Colleen


    When I txt 'this message should not go to everyone' to relay A
    Then I should receive a confirmation txt
    And Bob should receive '@Alice sez: this message should not go to everyone' from relay A
    And Colleen should not receive a message

  Scenario: Create a relay
    Given the number buyer will buy number 123
    And I am subscribed as an admin
    And someone is subscribed to relay A as Bob
    And I txt '/create B'

    Then I should receive a created txt from 123

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that relay B has number 123
    And I should see that I am subscribed to relay B
    But I should not see that Bob is subscribed to relay B
