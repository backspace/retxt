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

  Scenario: Users subscribe to different relays
    Given I am signed in as an admin

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
