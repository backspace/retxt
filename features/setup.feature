Feature: Setup wizard

  Scenario: Set up fresh application
    Given the number buyer will buy number 123

    When I visit the site
    Then I should be required to create an account

    When I create an account
    Then I should be required to enter my name and phone number

    When I enter my name and phone number +15145551313
    Then I should see that my number is from area code 514 in Canada
    And I should be required to name the relay

    When I name the relay
    Then I should receive a txt that a relay was created from 123
    And I should see that relay 123 has been created

    When I visit the users list
    Then I should see that admin@example.com is a site admin

    When I visit the subscribers list
    Then I should see myself

  Scenario: Set up with an existing number
    When I visit the site
    Then I should be required to create an account

    When I create an account
    Then I should be required to enter my name and phone number

    When I enter my name and phone number +358020071000
    Then I should see that my number is from Finland
    And I should be required to name the relay

    When I name the relay and give it the number 2345
    Then I should receive a txt that a relay was created from 2345
    And I should see that relay 2345 has been created
