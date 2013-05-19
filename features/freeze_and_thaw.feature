Feature: Freeze and thaw

  Scenario: Prevent relaying when frozen
    Given two other people are subscribed
    And I am subscribed as an admin

    When I txt '/freeze'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is frozen

    When I txt 'a train derailed'
    Then I should receive a message that the relay is frozen
    And subscribers other than me should not receive that message

    When I txt '/thaw'
    And I visit the subscribers list
    Then I should not see that the relay is frozen
