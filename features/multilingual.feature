Feature: Support multiple languages

  Scenario: Subscribe command sets language
    When I txt 'ubscribesay'
    Then I should receive a welcome txt in Pig Latin

    When I txt 'aboutay'
    Then I should receive a help txt in Pig Latin

  Scenario: Subscriber can change language
    Given I am subscribed
    And Alice is subscribed in English
    And Bob is subscribed in Pig Latin

    When I txt 'lang'
    Then I should receive a txt that lists the available languages

    When I txt 'lang igpay atinlay'
    Then I should receive a txt in Pig Latin that my language has been changed to Pig Latin

    When I txt 'ellohay everyoneay'
    Then I should receive a txt in Pig Latin that confirms the message was relayed
    And subscribers other than me should receive that message signed by anon

    When I txt 'anglay en'
    Then I should receive a txt in English that my language has been changed to English

  Scenario: Admins get messages in their own language
    Given Alice is subscribed as an admin in English
    And Bob is subscribed as an admin in Pig Latin

    When I txt 'ubscribesay'
    Then Alice should receive a txt saying anon subscribed in English
    And Bob should receive a txt saying anon subscribed in Pig Latin

  Scenario: Admins are notified of failed language changes
    Given someone is subscribed as Bob
    And Alice is subscribed as an admin

    When Bob txts 'lang nonlang'
    Then Bob should receive a txt in English that the language was not found
    And Alice should receive a txt that Bob tried to switch to an unknown language

    When I txt 'lang en'
    Then I should receive a txt that the command failed because I am not subscribed
    And Alice should receive a txt that someone tried to switch languages while not subscribed
