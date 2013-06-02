Feature: Freeze and thaw

  Scenario: Prevent relaying when frozen
    Given two other people are subscribed
    And I am subscribed as an admin
    And 'alice' is subscribed as an admin

    When 'alice' txts '/freeze'
    Then I should receive a txt including '@alice froze the relay'
    And 'alice' should receive a txt including '@alice froze the relay'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is frozen

    When I txt 'a train derailed'
    Then I should receive a message that the relay is frozen
    And subscribers other than me should not receive that message

    When 'alice' txts '/thaw'
    Then I should receive a txt including '@alice thawed the relay'
    And 'alice' should receive a txt including '@alice thawed the relay'

    When I visit the subscribers list
    Then I should not see that the relay is frozen
