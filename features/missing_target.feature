Feature: Cannot update non-existent subscriber
  Scenario: Try to make non-existent subscriber an admin
    Given I am subscribed as an admin
    When I txt '/admin @Alice'
    Then I should receive a txt that the target could not be found
