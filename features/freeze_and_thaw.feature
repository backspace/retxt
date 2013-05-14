Feature: Freeze and thaw

  Scenario: Prevent relaying when frozen
    Given two other people are subscribed
    And the relay is frozen
    And I am subscribed

    When I txt 'a train derailed'
    Then I should receive a message that the relay is frozen
    And subscribers other than me should not receive that message

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is frozen
