Feature: Get help

  Scenario: User requests help message
    Given I am subscribed
    When I txt 'help'
    Then I should receive a help txt
