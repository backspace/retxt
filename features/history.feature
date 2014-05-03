Feature: History

  Scenario: Messages are counted
    Given I am subscribed
    When I txt 'about'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see myself
    And I should have sent 1 message

    When I txt 'name anewname'
    And I visit the subscribers list
    Then I should have sent 2 messages

  Scenario: View message history
    Given I am subscribed as 'alice'
    And someone is subscribed as 'bob'
    And someone is subscribed as 'colleen'

    When I txt 'hello everyone'
    And I txt '@colleen we should hang'

    Given I am signed in as an admin
    When I view the message history for alice
    Then I should see that alice sent 'hello everyone'
    And I should see that bob received '@alice sez: hello everyone'
    And I should see that colleen received '@alice sez: hello everyone'
    And I should see that alice received a confirmation txt

    And I should see that alice sent '@colleen we should hang'
    And I should see that colleen received '@alice said to you: @colleen we should hang'
    And I should see that alice received a directconfirmation txt
