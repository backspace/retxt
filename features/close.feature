Feature: Close

  Scenario: Close subscriptions
    Given Alice is subscribed as an admin
    And someone is subscribed to relay X as Bob at 1337

    When Alice txts '/close'
    Then Alice should receive a txt that Alice closed subscriptions

    When Bob txts 'subscribe'
    Then Bob should receive a txt that subscriptions are closed
    And Alice should receive a txt that Bob tried to subscribe

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is closed

    When Alice txts '/open'
    Then Alice should receive a txt that Alice opened subscriptions

    When I visit the subscribers list
    Then I should not see that the relay is closed
