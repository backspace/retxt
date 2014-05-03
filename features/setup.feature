Feature: Setup wizard

  Scenario: Set up fresh application
    Given the number buyer will buy number 123

    When I visit the site
    Then I should be required to create an account

    When I create an account
    Then I should be required to enter my phone number

    When I enter my phone number
    Then I should receive a created txt from 123
    And I should see that relay 123 has been created

    When I visit the users list
    Then I should see that 'admin@example.com' is a site admin

    When I visit the subscribers list
    Then I should see myself
