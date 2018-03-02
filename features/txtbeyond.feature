Feature: txtbeyond

  Scenario: Scheduled messages get sent out
    Given team GX is GXA, GXB
    And team GY is GYA
    And team GA is GAA
    And team GB is GBA

    And a GYA-chosen meeting XY at Leatherdale is scheduled at offset 15 between GX, GY
    And a meeting AB at Ashdown is scheduled at offset 20 between GA, GB

    And it is offset 18

    When the txts are sent
    Then GXA should receive a message about the meeting at Leatherdale
    Then GXB should receive a message about the meeting at Leatherdale
    And GYA should receive a chosen message about the meeting at Leatherdale

    And GAA should not receive a message
    And GBA should not receive a message

    Given it is offset 22
    When the txts are sent

    And GXA should have only received 1 message
    And GXB should have only received 1 message

  Scenario: I txt the meeting group
    Given I am on team US
    And US2 is on team US
    And team GX is GXA
    And team GY is GYA
    And Jorty is subscribed as an admin

    And a meeting M at Centennial is scheduled between US, GX, GY

    When I txt '@M hello'
    Then I should receive a confirmation that my message was sent to meeting group M
    And GXA should receive '@me of @US said to meeting group @M: hello'
    And GYA should receive '@me of @US said to meeting group @M: hello'
    And Jorty should receive '@me of @US said to meeting group @M: hello'
    And US2 should receive '@me of @US said to meeting group @M: hello'

  Scenario: I txt the codes of the assembled teams
    Given I am on team US with code 123
    And team GX with code 234 is GXA
    And team GY with code 345 is GYA

    And a meeting M at Centennial is scheduled between US, GX, GY

    When I txt '?M123234345'
    Then I should receive a txt with links for a meeting M at Centennial

    When I txt '?111'
    Then I should receive a txt that the codes were not recognised

  Scenario: I txt the answer for the meeting
    Given I am on team US
    And team GX is GXA
    And a meeting M at Centennial with answer jortle is scheduled between US, GX

    When I txt '!M jortle'
    Then I should receive a txt with a portion of the final answer

    When I txt '!M shartle'
    Then I should receive a txt that the answer was incorrect

    When I txt '!X whatever'
    Then I should receive a txt that the meeting was not found
