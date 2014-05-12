Feature: Support multiple languages

  Scenario: Subscribe command sets language
    When I txt 'ubscribesay'
    Then I should receive a welcome txt in Pig Latin

    When I txt 'aboutay'
    Then I should receive a help txt in Pig Latin

  Scenario: Admins get messages in their own language
    Given 'alice' is subscribed as an admin in English
    And 'bob' is subscribed as an admin in Pig Latin

    When I txt 'ubscribesay'
    Then 'alice' should receive a txt saying anon subscribed in English
    And 'bob' should receive a txt saying anon subscribed in Pig Latin
