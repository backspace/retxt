Feature: Freeze and thaw

  Scenario: Prevent relaying when frozen
    Given two other people are subscribed
    And the relay is frozen
    And I am subscribed

    When I txt 'a train derailed'
    Then I should receive a message that the relay is frozen
    And subscribers other than me should not receive that message
