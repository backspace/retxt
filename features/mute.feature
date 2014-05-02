Feature: Mute

  Scenario: Mute a subscriber
    Given 'alice' is subscribed as an admin
    And someone is subscribed as 'bob'
    And 'colleen' is subscribed as an admin

    When 'alice' txts '/mute @bob'
    Then 'alice' should receive a txt including '@alice muted @bob'
    And 'colleen' should receive a txt including '@alice muted @bob'

    When 'bob' txts 'I want to relay something'
    Then 'bob' should receive a txt including 'did not forward your message because you have been muted by an admin'
    And the admin should receive a txt including '@bob tried to say: I want to relay something'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'bob' is muted

    When 'alice' txts '/unmute @bob'
    Then 'alice' should receive a txt including '@alice unmuted @bob'

    When I visit the subscribers list
    Then I should not see that 'bob' is muted
