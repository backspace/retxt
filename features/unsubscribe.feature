Feature: Unsubscribe

  Scenario: A user unsubscribes
    Given someone is subscribed to relay A as Bob
    And I am subscribed to relay A as an admin
    When Bob txts 'unsubscribe' to relay A
    Then Bob should receive a txt that they are unsubscribed
    And I should receive a txt saying Bob unsubscribed

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see that Bob is subscribed to relay A

  Scenario: A non-subscriber unsubscribes
    When Alice is subscribed as an admin
    And I txt 'unsubscribe'
    Then I should receive a txt that I could not be unsubscribed
    And Alice should receive a txt that someone tried to unsubscribe that is not subscribed
