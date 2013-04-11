Feature: Subscribe

  Scenario: A user subscribes
    Given an admin is subscribed
    When I txt 'subscribe'
    Then I should receive a welcome txt saying my name is 'anon'
    And the admin should receive a txt saying anon subscribed

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see myself

  Scenario: A user subscribes with a name
    When I txt 'subscribe morrison'
    Then I should receive a welcome txt saying my name is 'morrison'

  Scenario: A subscribed user tries to subscribe
    Given I am subscribed
    When I txt 'subscribe'
    Then I should receive an already-subscribed txt
