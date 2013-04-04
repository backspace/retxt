Feature: Relay

  Scenario: Relay a txt to subscribers
    Given I am subscribed
    And two other people are subscribed

    When I txt 'a tornado is destroying super c'

    Then subscribers other than me should receive that message
    And I should receive a confirmation txt
