Feature: txtbeyond

  Scenario: I txt the codes of the assembled teams
    Given I am subscribed as US with code 123
    And someone is subscribed as GX with code 234
    And someone is subscribed as GY with code 345

    And a meeting M is scheduled between US, GX, GY

    When I txt '!M123234345'
    Then I should receive a txt with links for meeting M

    When I txt '!111'
    Then I should receive a txt that the codes were not recognised

  Scenario: Scheduled messages get sent out
    Given someone is subscribed as GX
    And someone is subscribed as GY
    And someone is subscribed as GA
    And someone is subscribed as GB

    And a meeting MXY is scheduled at offset 15 between GX, GY
    And a meeting MAB is scheduled at offset 20 between GA, GB

    And it is offset 18

    When the txts are sent
    Then GX should receive a message about meeting MXY
    And GY should receive a message about meeting MXY

    And GA should not receive a message
    And GB should not receive a message
