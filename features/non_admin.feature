Feature: Bounce non-admin commands

  Scenario: A non-admin tries to rename a relay
    Given I am subscribed
    And Alice is subscribed as an admin
    When I txt '/rename Z'
    Then I should receive a non-admin txt
    And Alice should receive a non-admin-attempt txt
