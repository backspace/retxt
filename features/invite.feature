Feature: Invite

  Scenario: An admin invites a number
    Given Alice is subscribed as an admin
    When Alice txts '/invite 1919'
    Then Alice should receive a txt that 1919 was invited
    And 1919 should receive an invitation
