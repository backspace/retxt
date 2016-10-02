Feature: Multi-relay

  Scenario: Relay a txt on one relay
    Given I am subscribed to relay A as Alice
    And someone is subscribed to relay A as Bob

    Given I am subscribed to relay B
    And someone is subscribed to relay B as Colleen


    When I txt 'this message should not go to everyone' to relay A
    Then I should receive a txt that confirms the message was relayed
    And Bob should receive '@Alice says: this message should not go to everyone' from relay A
    And Colleen should not receive a message

  Scenario: Create a relay
    Given the number buyer will buy number 123
    And I am subscribed to relay A as an admin as Alice

    And someone is subscribed to relay A as Bob
    And Alice txts '/create B'

    Then Alice should receive a txt that a relay was created from 123

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that relay B has number 123
    And I should see that Alice is subscribed to relay B
    But I should not see that Bob is subscribed to relay B
