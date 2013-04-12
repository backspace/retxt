Feature: Store messages

  Scenario: Messages are counted
    Given I am subscribed
    When I txt 'about'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see myself
    And I should have sent 1 message

    When I txt 'another message'
    And I visit the subscribers list
    Then I should have sent 2 messages
