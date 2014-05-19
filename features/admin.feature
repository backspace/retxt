Feature: Admin

  Scenario: Make a subscriber an admin
    Given Alice is subscribed as an admin
    And Bob is subscribed as an admin
    And someone is subscribed as Colleen

    When Alice txts '/admin @Colleen'
    Then Colleen should receive a txt that Alice made Colleen an admin
    And Alice should receive a txt that Alice made Colleen an admin
    And Bob should receive a txt that Alice made Colleen an admin

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that Colleen is an admin

  Scenario: Demote an admin
    Given Alice is subscribed as an admin
    And Bob is subscribed as an admin
    And Colleen is subscribed as an admin

    When Colleen txts '/unadmin @Bob'
    Then Alice should receive a txt that Colleen made Bob not an admin
    And Colleen should receive a txt that Colleen made Bob not an admin

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should not see that Bob is an admin
