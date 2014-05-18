Feature: Timestamps

  Scenario: Admin enables timestamps
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'bob' at '1234'

    When I txt '/timestamp %l:%M'
    Then I should receive a timestamp txt

    When I txt 'hello' at 13:10
    Then I should receive a confirmation txt
    And subscribers other than me should receive that 1:10-timestamped message signed by 'alice'

    When I txt '@bob you are areshum' at 13:15
    Then I should receive a directconfirmation txt
    And bob should receive a 1:15-timestamped direct message from alice saying 'you are areshum'

    When I txt '/timestamp'
    Then I should receive a timestamp txt

    When I txt 'hello again'
    Then subscribers other than me should receive that message signed by 'alice'
