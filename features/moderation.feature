Feature: Moderation

  Scenario: Admin moderates list
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'bob' at '1234'

    When I txt '/moderate'
    Then I should receive a moderated txt

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is moderated

    When I txt 'hello all'
    Then subscribers other than me should receive that message signed by 'alice'

    When 'bob' txts 'me too'
    Then 'bob' should receive a txt including 'forwarded your message to admins because the relay is moderated'
    And 'alice' should receive a txt including '@bob#1234 tried to say: me too'

  Scenario: Admin gives voice
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'colleen'
    And 'dreya' is subscribed as an admin

    When I txt '/moderate'
    Then I should receive a moderated txt

    When I txt '/voice @colleen'
    Then 'alice' should receive a txt including '@alice voiced @colleen'
    And 'dreya' should receive a txt including '@alice voiced @colleen'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'colleen' is voiced

    When 'colleen' txts 'i have voice'
    Then subscribers other than colleen should receive that message signed by 'colleen'

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
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'bob'
    And 'colleen' is subscribed as an admin

    When I txt '/voice @bob'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'bob' is voiced

    When I txt '/unvoice @bob'
    Then I should receive a txt including '@alice unvoiced @bob'
    And 'colleen' should receive a txt including '@alice unvoiced @bob'

    When I visit the subscribers list
    Then I should not see that 'bob' is voiced
