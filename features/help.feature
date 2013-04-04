Feature: Get help

  Scenario: User requests help message
    When I txt 'help'
    Then I should receive a help txt
