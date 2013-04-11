Feature: Names

  Scenario: I check my name
    Given I am subscribed as 'nikanj'
    When I txt 'name'
    Then I should receive a txt saying my name is 'nikanj'

  Scenario: I change my name
    Given I am subscribed
    When I txt 'name'
    Then I should receive a txt saying my name is 'anon'

    When I txt 'name leguin'
    Then I should receive a txt saying my name is 'leguin'
