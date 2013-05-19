Feature: Mute

  Scenario: Mute a subscriber
    Given I am subscribed as an admin
    And someone is subscribed as 'bob'

    When I txt '/mute @bob'
    Then I should receive a txt including '@bob is muted'

    When 'bob' txts 'I want to relay something'
    Then 'bob' should receive a txt including 'did not forward your message because you have been muted by an admin'
    And the admin should receive a txt including '@bob tried to say: I want to relay something'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'bob' is muted

    When I txt '/unmute @bob'
    Then I should receive a txt including '@bob is unmuted'

    When I visit the subscribers list
    Then I should not see that 'bob' is muted
