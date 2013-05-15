Feature: Who

  Scenario: List who is subscribed to a relay
    Given I am subscribed to relay A as an admin as 'alice' at '000'
    And outgoing txts are monitored

    And someone is subscribed to relay A as 'bob' at '123'
    And someone is subscribed to relay A as 'colleen' at '456'
    And someone is subscribed to relay A at '678'
    And someone is subscribed to relay A as '01234567890123456789' at '01234567890123456789'
    And someone is subscribed to relay A as '98765432109876543210' at '98765432109876543210'
    And someone is subscribed to relay A as '9876543210987654321' at '9876543210987654321'
    And someone is subscribed to relay A as '987654321098765432' at '987654321098765432'
    And someone is subscribed to relay A as '98765432109876543' at '98765432109876543'

    And someone is subscribed to relay B as 'dean'

    When I txt '/who' to relay A
    Then I should receive a txt including
    """
    @alice* 000
    @bob 123
    @colleen 456
    anon 678
    @01234567890123456789 01234567890123456789
    @98765432109876543210 98765432109876543210
    """

    And I should receive a txt including
    """
    @9876543210987654321 9876543210987654321
    @987654321098765432 987654321098765432
    @98765432109876543 98765432109876543
    """
