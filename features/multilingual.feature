Feature: Support multiple languages

  Scenario: Subscribe command sets language
    When I txt 'ubscribesay'
    Then I should receive a welcome txt in Pig Latin
