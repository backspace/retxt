Feature: Unsubscribe

  Scenario: A user unsubscribes
    Given I am subscribed
    When I txt 'unsubscribe'
    Then I should receive a goodbye txt

    When I visit the subscribers list
    Then I should not see myself
