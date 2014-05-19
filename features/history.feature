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
    Given I am subscribed as Alice
    And someone is subscribed as Bob
    And someone is subscribed as Colleen

    When I txt 'hello everyone'
    And I txt '@Colleen we should hang'

    Given I am signed in as an admin
    When I view the message history for Alice
    Then I should see that Alice sent 'hello everyone'
    And I should see that Bob received '@Alice sez: hello everyone'
    And I should see that Colleen received '@Alice sez: hello everyone'
    And I should see that Alice received a confirmation txt

    And I should see that Alice sent '@Colleen we should hang'
    And I should see that Colleen received '@Alice said to you: @Colleen we should hang'
    And I should see that Alice received a directconfirmation txt
