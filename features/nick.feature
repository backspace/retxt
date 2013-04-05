Feature: Nicks

  Scenario: I check my nick
    Given I am subscribed as 'nikanj'
    When I txt 'nick'
    Then I should receive a txt saying my nick is 'nikanj'

  Scenario: I change my nick
    Given I am subscribed
    When I txt 'nick'
    Then I should receive a txt saying my nick is 'anon'

    When I txt 'nick leguin'
    Then I should receive a txt saying my nick is 'leguin'
