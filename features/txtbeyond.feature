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
