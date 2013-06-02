Feature: Moderation

  Scenario: Admin moderates list
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'bob'

    When I txt '/moderate'
    Then I should receive a moderated txt

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that the relay is moderated

    When I txt 'hello all'
    Then subscribers other than me should receive that message signed by 'alice'

    When 'bob' txts 'me too'
    Then 'bob' should receive a txt including 'did not forward your message because the relay is moderated'
    And 'alice' should receive a txt including '@bob tried to say: me too'

  Scenario: Admin gives voice
    Given I am subscribed as an admin as 'alice'
    And someone is subscribed as 'colleen'

    When I txt '/moderate'
    Then I should receive a moderated txt

    When I txt '/voice @colleen'
    Then I should receive a txt including '@colleen is voiced'

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
    Given I am subscribed as an admin
    And someone is subscribed as 'bob'

    When I txt '/voice @bob'
    Then I should receive a txt including '@bob is voiced'

    Given I am signed in as an admin
    When I visit the subscribers list
    Then I should see that 'bob' is voiced

    When I txt '/unvoice @bob'
    Then I should receive a txt including '@bob is unvoiced'

    When I visit the subscribers list
    Then I should not see that 'bob' is voiced
