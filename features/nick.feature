Feature: Nicks

  Scenario: I check my nick
    Given I am subscribed as 'nikanj'
    When I txt 'nick'
    Then I should receive a txt saying my nick is 'nikanj'
