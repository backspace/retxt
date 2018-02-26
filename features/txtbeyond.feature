Feature: txtbeyond

  Scenario: I txt the codes of the assembled teams
    Given I am subscribed as US with code 123
    And someone is subscribed as GX with code 234
    And someone is subscribed as GY with code 345

    And a meeting M at Centennial is scheduled between US, GX, GY

    When I txt '!M123234345'
    Then I should receive a txt with links for a meeting M at Centennial

    When I txt '!111'
    Then I should receive a txt that the codes were not recognised

  Scenario: Scheduled messages get sent out
    Given someone is subscribed as GX
    And someone is subscribed as GY
    And someone is subscribed as GA
    And someone is subscribed as GB

    And a meeting XY at Leatherdale is scheduled at offset 15 between GX, GY
    And a meeting AB at Ashdown is scheduled at offset 20 between GA, GB

    And it is offset 18

    When the txts are sent
    Then GX should receive a message about the meeting at Leatherdale
    And GY should receive a message about the meeting at Leatherdale

    And GA should not receive a message
    And GB should not receive a message

    Given it is offset 22
    When the txts are sent

    And GX should have only received 1 message