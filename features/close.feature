Feature: Close

  Scenario: Close subscriptions
    Given I am subscribed as an admin
    And someone is subscribed to relay X as 'bob'

    When I txt '/close'
    Then I should receive a txt including 'subscriptions are closed'

    When 'bob' txts 'subscribe'
    Then 'bob' should receive a txt including 'subscriptions are closed'
    And the admin should receive a txt including 'tried to subscribe'
