Feature: Close

  Scenario: Close subscriptions
    Given 'alice' is subscribed as an admin
    And someone is subscribed to relay X as 'bob' at '1337'

    When 'alice' txts '/close'
    Then alice should receive a txt that alice closed subscriptions

    When 'bob' txts 'subscribe'
    Then bob should receive a txt that subscriptions are closed
    And alice should receive a txt that bob tried to subscribe

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is closed

    When 'alice' txts '/open'
    Then alice should receive a txt that alice opened subscriptions

    When I visit the subscribers list
    Then I should not see that the relay is closed
