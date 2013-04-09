Feature: Unsubscribe

  Scenario: A user unsubscribes
    Given I am subscribed
    And an admin is subscribed
    When I txt 'unsubscribe'
    Then I should receive a goodbye txt
    And the admin should receive a txt saying anon unsubscribed

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see myself

  Scenario: A non-subscriber unsubscribes
    When I txt 'unsubscribe'
    Then I should receive a message that I am not subscribed
