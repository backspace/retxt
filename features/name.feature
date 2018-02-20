@wip
Feature: Names

  Scenario: I check my name
    Given I am subscribed as Nikanj
    When I txt 'name'
    Then I should receive a txt saying my name is Nikanj

  Scenario: I change my name
    Given I am subscribed
    When I txt 'name'
    Then I should receive a txt saying my name is anon

    When I txt 'name Leguin'
    Then I should receive a txt saying my name is Leguin

  Scenario: I change my name to an existing name, case-insensitive
    Given someone is subscribed as test
    And I am subscribed

    When I txt 'name Test'
    Then I should receive a txt saying my name is Test1

  Scenario: I try to change my name to the same name
    Given I am subscribed as Francine
    When I txt 'name Francine'
    Then I should receive a txt saying my name is Francine
