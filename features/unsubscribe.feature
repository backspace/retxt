Feature: Unsubscribe

  Scenario: A user unsubscribes
    Given I am subscribed
    When I txt 'unsubscribe'
    Then I should receive a goodbye txt

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see myself

  Scenario: A non-subscriber unsubscribes
    When I txt 'unsubscribe'
    Then I should receive a message that I am not subscribed
