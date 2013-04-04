Feature: Relay

  Scenario: Relay a txt to subscribers
    Given I am subscribed
    And two other people are subscribed

    When I txt 'a tornado is destroying super c'

    Then subscribers other than me should receive that message
    And I should receive a confirmation txt

  Scenario: Non-subscriber tries to relay
    Given two other people are subscribed
    When I txt 'a giant sucking sound is emanating from the metro'
    Then subscribers other than me should not receive that message
    And I should receive a message that I am not subscribed
