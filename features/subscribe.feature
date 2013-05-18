Feature: Subscribe

  Scenario: A user subscribes
    Given an admin is subscribed
    And outgoing txts are monitored
    When I txt 'subscribe'
    Then I should receive a welcome txt saying my name is 'anon'
    And the admin should receive a txt saying anon subscribed

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see myself

  Scenario: A user subscribes with a name
    Given outgoing txts are monitored
    When I txt 'subscribe morrison'
    Then I should receive a welcome txt saying my name is 'morrison'

  Scenario: A subscribed user tries to subscribe
    Given I am subscribed
    And outgoing txts are monitored
    When I txt 'subscribe'
    Then I should receive an already-subscribed txt

  Scenario: Users subscribe to different relays
    Given I am signed in as an admin
    And outgoing txts are monitored

    And someone is subscribed to relay A as 'alice'
    And someone is subscribed to relay B as 'bob'

    When I visit the subscribers list
    Then I should see that 'alice' is subscribed to relay A
    And I should see that 'bob' is subscribed to relay B

    But I should not see that 'alice' is subscribed to relay B
    And I should not see that 'bob' is subscribed to relay A


    When 'bob' txts 'subscribe' to relay A
    And I visit the subscribers list
    Then I should see that 'bob' is subscribed to relay A
