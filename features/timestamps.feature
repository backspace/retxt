Feature: Timestamps

  Scenario: Admin enables timestamps
    Given I am subscribed as an admin as Alice
    And someone is subscribed as Bob at 1234

    When I txt '/timestamp %l:%M' at 13:00
    Then I should receive a txt that Alice set the relay timestamp to %l:%M

    When I txt 'hello' at 13:10
    And subscribers other than me should receive that 1:10-timestamped message signed by Alice

    When I txt '@Bob you are areshum' at 13:15
    And Bob should receive a 1:15-timestamped direct message from Alice saying 'you are areshum'

    When I txt '/timestamp' at 13:20
    Then I should receive a txt that Alice set the relay timestamp to blank

    When I txt 'hello again' at 13:25
    Then subscribers other than me should receive that message signed by Alice
