Feature: Direct message

  Scenario: I direct message someone
    Given I am subscribed as 'alice'
    And someone is subscribed as 'bob'
    And someone is subscribed as 'colleen'


    When I txt '@bob you are kewl'
    Then I should receive a directconfirmation txt
    And bob should receive '@alice said to you: @bob you are kewl'
    And colleen should not receive 'you are kewl'

  Scenario: I direct message a non-existent subscriber
    Given I am subscribed as 'alice'
    When I txt '@francine i love you'
    Then I should receive a txt including 'your message was not sent because @francine could not be found'
