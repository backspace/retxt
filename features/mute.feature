Feature: Mute

  Scenario: Mute a subscriber
    Given I am subscribed as an admin
    And someone is subscribed as 'bob'

    When I txt '/mute @bob'
    Then I should receive a txt including '@bob is muted'

    When 'bob' txts 'I want to relay something'
    Then 'bob' should receive a txt including 'have been muted'
    And the admin should receive a txt including '@bob tried to say'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'bob' is muted
