Feature: Support multiple languages

  Scenario: Subscribe command sets language
    When I txt 'ubscribesay'
    Then I should receive a welcome txt in Pig Latin

    When I txt 'aboutay'
    Then I should receive a help txt in Pig Latin

  Scenario: Admins get messages in their own language
    Given Alice is subscribed as an admin in English
    And Bob is subscribed as an admin in Pig Latin

    When I txt 'ubscribesay'
    Then Alice should receive a txt saying anon subscribed in English
    And Bob should receive a txt saying anon subscribed in Pig Latin
