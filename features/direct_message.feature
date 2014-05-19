Feature: Direct message

  Scenario: I direct message someone
    Given I am subscribed as Alice
    And someone is subscribed as Bob
    And someone is subscribed as Colleen


    When I txt '@Bob you are kewl'
    Then I should receive a txt that confirms the direct message was sent
    And Bob should receive a direct message from Alice saying 'you are kewl'
    And Colleen should not receive a direct message from Alice saying 'you are kewl'

  Scenario: I direct message a non-existent subscriber
    Given I am subscribed as Alice
    When I txt '@Francine i love you'
    Then I should receive a direct message bounce response because @Francine could not be found

  Scenario: I cannot direct message when anonymous
    Given I am subscribed
    When I txt '@Pascal gay marry me!'
    Then I should receive a txt that anonymous subscribers cannot send direct messages
