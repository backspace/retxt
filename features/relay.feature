Feature: Relay

  Scenario: Relay a txt to subscribers
    Given I am subscribed at '1234'
    And two other people are subscribed
    And 'alice' is subscribed as an admin

    When I txt 'a tornado is destroying super c'

    Then subscribers other than me should receive that message signed by 'anon'
    And I should receive a confirmation txt
    And alice should receive a txt that identifies the sender of the anonymous message

  Scenario: Relay a signed txt
    Given I am subscribed as 'fork'
    And two other people are subscribed

    When I txt 'the cross is on fire'

    Then subscribers other than me should receive that message signed by 'fork'
    And I should receive a confirmation txt

  Scenario: Non-subscriber tries to relay
    Given two other people are subscribed
    And 'alice' is subscribed as an admin

    When I txt 'a giant sucking sound is emanating from the metro'
    Then subscribers other than me should not receive that message
    And I should receive a message that I am not subscribed
    And 'alice' should receive a not-subscribed-notification txt
