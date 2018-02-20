Feature: Get help

  Scenario: User requests help message
    Given I am subscribed
    When I txt 'help'
    Then I should receive a help txt

  Scenario: User requests command help
    Given I am subscribed
    # When I txt 'help name'
    # Then I should receive a name help txt

    When I txt 'help /mute'
    Then I should receive a mute help txt

    When I txt 'help Voice'
    Then I should receive a voice help txt

    When I txt 'help meeee'
    Then I should receive an unknown help txt

  Scenario: Admin requests help message
    Given I am subscribed as an admin
    When I txt 'help'
    Then I should receive a help txt
    And I should receive an admin help txt
