Feature: Bounce non-admin commands

  Scenario: A non-admin tries to rename a relay
    Given I am subscribed
    And Alice is subscribed as an admin
    When I txt '/rename Z'
    Then I should receive a txt that I am not an admin
    And Alice should receive a txt that anon tried to run an admin command
