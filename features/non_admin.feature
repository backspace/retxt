Feature: Bounce non-admin commands

  Scenario: A non-admin tries to rename a relay
    Given I am subscribed
    When I txt '/rename Z'
    Then I should receive a non-admin txt
