Feature: Subscribe

  Scenario: A user subscribes
    When I txt 'subscribe'
    Then I should receive a welcome txt

    When I visit the subscribers list
    Then I should see myself
