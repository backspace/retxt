Feature: Names

  Scenario: I check my name
    Given I am subscribed as 'nikanj'
    And outgoing txts are monitored
    When I txt 'name'
    Then I should receive a txt saying my name is 'nikanj'

  Scenario: I change my name
    Given I am subscribed
    And outgoing txts are monitored
    When I txt 'name'
    Then I should receive a txt saying my name is 'anon'

    When I txt 'name leguin'
    Then I should receive a txt saying my name is 'leguin'

  Scenario: I change my name to an existing name
    Given someone is subscribed as 'test'
    And I am subscribed
    And outgoing txts are monitored

    When I txt 'name test'
    Then I should receive a txt saying my name is 'test1'
