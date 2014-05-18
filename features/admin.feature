Feature: Admin

  Scenario: Make a subscriber an admin
    Given 'alice' is subscribed as an admin
    And 'bob' is subscribed as an admin
    And someone is subscribed as 'colleen'

    When 'alice' txts '/admin @colleen'
    Then colleen should receive a txt that alice made colleen an admin
    And alice should receive a txt that alice made colleen an admin
    And bob should receive a txt that alice made colleen an admin

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'colleen' is an admin

  Scenario: Demote an admin
    Given 'alice' is subscribed as an admin
    And 'bob' is subscribed as an admin
    And 'colleen' is subscribed as an admin

    When 'colleen' txts '/unadmin @bob'
    Then alice should receive a txt that colleen made bob not an admin
    And colleen should receive a txt that colleen made bob not an admin

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see that 'bob' is an admin
