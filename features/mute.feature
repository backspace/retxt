Feature: Mute

  Scenario: Mute a subscriber
    Given Alice is subscribed as an admin
    And someone is subscribed as Bob
    And Colleen is subscribed as an admin

    When Alice txts '/mute @Bob'
    Then Alice should receive a txt that Alice muted Bob
    And Colleen should receive a txt that Alice muted Bob

    When Bob txts 'I want to relay something'
    Then Bob should receive a txt that they are muted
    And Alice should receive a txt that Bob tried to relay a message while muted

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that Bob is muted

    When Alice txts '/unmute @Bob'
    Then Alice should receive a txt that Alice unmuted Bob

    When I visit the subscribers list
    Then I should not see that Bob is muted
