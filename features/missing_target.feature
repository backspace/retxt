Feature: Cannot update non-existent subscriber
  Scenario: Try to make non-existent subscriber an admin
    Given I am subscribed as an admin
    When I txt '/admin @alice'
    Then I should receive a missing-target txt