Feature: User requests foreign exchange rates for a specific date

  @regression, @positive
  Scenario Outline: Requesting all available exchange rates against default currency for a specific date in the past

    Given User opens ratesapi page
    When User requests <endpoint>
    Then Request sent. Status code is 200
    And Response contains more than 20 rates against <base>
    And Response contains date same as listed in <endpoint>
    Examples:
      |endpoint         |base |
      |"/2010-01-12"    |"EUR"|
      |"/1999-01-04"    |"EUR"|
      |"$current_date-1"|"EUR"|

  @regression, @positive
  Scenario Outline: Requesting specific exchange rates against default currency for a specific date in the past

    Given User opens ratesapi page
    When User requests <endpoint> using the following <symbols> as <params>
    Then Request sent. Status code is 200
    And Response contains value listed in <symbols>
    And Response contains date same as listed in <endpoint>
    Examples:
      |endpoint     |symbols     |params   |
      |"/2010-01-12"|"USD"       |"symbols"|
      |"/2019-10-11"|"PLN,GBP"   |"symbols"|

  @regression, @positive
  Scenario Outline: Requesting all available exchange rates against  a specific currency for a specific date in the past

    Given User opens ratesapi page
    When User requests <endpoint> using the following <base> as <params>
    Then Request sent. Status code is 200
    And Response contains value listed in <base>
    And Response contains date same as listed in <endpoint>
    Examples:
      |endpoint     |base |params|
      |"/2019-10-11"|"PLN"|"base"|

  @regression, @positive
  Scenario Outline: Requesting specific exchange rates against  a specific currency for a specific date in the past

    Given User opens ratesapi page
    When User requests <endpoint> using the following <base> and <symbols> params
    Then Request sent. Status code is 200
    And Response contains value listed in <base>
    And Response contains value listed in <symbols>
    And Response contains date same as listed in <endpoint>
    Examples:
      |endpoint     |base |symbols|
      |"/2019-10-11"|"PLN"|"USD"  |
      |"/2010-01-12"|"GBP"|"EUR"  |

  @positive
  Scenario Outline: Requesting all available exchange rates against default currency for a specific date in the future

    Given User opens ratesapi page
    When User requests <endpoint>
    Then Request sent. Status code is 200
    And Response contains more than 20 rates against <base>
    And Response contains current date
    Examples:
      |endpoint     |base |
      |"/2022-01-12"|"EUR"|

  @negative
  Scenario Outline: Requesting all available exchange rates against default currency for a specific date before 1999-01-04

    Given User opens ratesapi page
    When User requests <endpoint>
    Then Request sent. Status code is 400
    And Response contains <error message>
    Examples:
      |endpoint     |error message                                      |
      |"/1999-01-03"|"There is no data for dates older then 1999-01-04."|