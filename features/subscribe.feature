Feature: Subscribe

  Scenario: A user subscribes
    When I txt 'subscribe'
    Then I should receive a welcome txt

    When I visit the subscribers list
    Then I should see myself

  Scenario: A user subscribes with a nick
    When I txt 'subscribe morrison'
    Then I should receive a welcome txt saying my nick is 'morrison'

  Scenario: A subscribed user tries to subscribe
    Given I am subscribed
    When I txt 'subscribe'
    Then I should receive an already-subscribed txt
