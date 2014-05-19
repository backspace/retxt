Feature: Moderation

  Scenario: Admin moderates list
    Given I am subscribed as an admin as Alice
    And someone is subscribed as Bob at 1234

    When I txt '/moderate'
    Then I should receive a moderated txt

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is moderated

    When I txt 'hello all'
    Then subscribers other than me should receive that message signed by Alice

    When Bob txts 'me too'
    Then Bob should receive a txt that the relay is moderated
    And Alice should receive a txt that Bob tried to relay a message under moderation

  Scenario: Admin gives voice
    Given I am subscribed as an admin as Alice
    And someone is subscribed as Colleen
    And Dreya is subscribed as an admin

    When I txt '/moderate'
    Then I should receive a moderated txt

    When I txt '/voice @Colleen'
    Then Alice should receive a txt that Alice voiced Colleen
    And Dreya should receive a txt that Alice voiced Colleen

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that Colleen is voiced

    When Colleen txts 'i have voice'
    Then subscribers other than Colleen should receive that message signed by Colleen

  Scenario: Admin unmoderates list
    Given I am subscribed as an admin
    When I txt '/moderate'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is moderated

    When I txt '/unmoderate'
    Then I should receive an unmoderated txt

    When I visit the subscribers list
    Then I should not see that the relay is moderated

  Scenario: Admin removes voices
    Given I am subscribed as an admin as Alice
    And someone is subscribed as Bob
    And Colleen is subscribed as an admin

    When I txt '/voice @Bob'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that Bob is voiced

    When I txt '/unvoice @Bob'
    Then I should receive a txt that Alice unvoiced Bob
    And Colleen should receive a txt that Alice unvoiced Bob

    When I visit the subscribers list
    Then I should not see that Bob is voiced
