Feature: Close

  Scenario: Close subscriptions
    Given I am subscribed as an admin
    And someone is subscribed to relay X as 'bob' at '1337'

    When I txt '/close'
    Then I should receive a txt including 'subscriptions are closed'

    When 'bob' txts 'subscribe'
    Then 'bob' should receive a txt including 'subscriptions are closed'
    And the admin should receive a txt including '1337 tried to subscribe: subscribe'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is closed

    When I txt '/open'
    And I visit the subscribers list
    Then I should not see that the relay is closed
