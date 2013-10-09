Feature: Timestamps

  Scenario: Admin enables timestamps
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'bob' at '1234'

    When I txt '/timestamp %l:%M'
    Then I should receive a timestamp txt

    When I txt 'hello' at 13:10
    Then I should receive a confirmation txt
    And 'bob' should receive a txt including '1:10 @alice sez: hello'

    When I txt '@bob you are areshum' at 13:15
    Then I should receive a directconfirmation txt
    And bob should receive '1:15 @alice said to you: @bob you are areshum'

    When I txt '/timestamp'
    Then I should receive a timestamp txt

    When I txt 'hello again'
    And 'bob' should receive a txt including '@alice sez: hello again'
