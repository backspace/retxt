Feature: Bounce non-admin commands

  Scenario: A non-admin tries to rename a relay
    Given I am subscribed
    And outgoing txts are monitored
    When I txt '/rename Z'
    Then I should receive a non-admin txt
