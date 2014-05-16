Feature: Unsubscribe

  Scenario: A user unsubscribes
    Given someone is subscribed to relay A as 'bob'
    And an admin is subscribed
    When 'bob' txts 'unsubscribe' to relay A
    Then 'bob' should receive a txt including 'goodbye'
    And the admin should receive a txt saying 'bob' unsubscribed

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see that 'bob' is subscribed to relay A

  Scenario: A non-subscriber unsubscribes
    When 'alice' is subscribed as an admin
    And I txt 'unsubscribe'
    Then I should receive a message that I am not subscribed
    And 'alice' should receive a not-subscribed-bounce-notification txt
