Feature: Get help

  Scenario: User requests help message
    Given I am subscribed
    When I txt 'help'
    Then I should receive a help txt

  Scenario: Admin requests help message
    Given I am subscribed as an admin
    When I txt 'help'
    Then I should receive a help txt
    And I should receive an admin help txt
