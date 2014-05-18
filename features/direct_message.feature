Feature: Direct message

  Scenario: I direct message someone
    Given I am subscribed as 'alice'
    And someone is subscribed as 'bob'
    And someone is subscribed as 'colleen'


    When I txt '@bob you are kewl'
    Then I should receive a directconfirmation txt
    And bob should receive a direct message from alice saying 'you are kewl'
    And colleen should not receive a direct message from alice saying 'you are kewl'

  Scenario: I direct message a non-existent subscriber
    Given I am subscribed as 'alice'
    When I txt '@francine i love you'
    Then I should receive a direct message bounce response because @francine could not be found

  Scenario: I cannot direct message when anonymous
    Given I am subscribed
    When I txt '@pascal gay marry me!'
    Then I should receive a no-anon-direct txt
