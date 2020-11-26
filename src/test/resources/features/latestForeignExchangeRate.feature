Feature: User requests latest foreign exchange rates

  @regression, @positive
Scenario Outline: Requesting all available exchange rates against default currency for a current date

Given User opens ratesapi page
When User requests <endpoint>
Then Request sent. Status code is 200
And Response contains more than 20 rates against <base>
And Response contains current date
  Examples:
  |endpoint |base |
  |"/latest"|"EUR"|

  @regression, @positive
  Scenario Outline: Requesting specific exchange rates against default currency for a current date

    Given User opens ratesapi page
    When User requests <endpoint> using the following <symbols> as <params>
    Then Request sent. Status code is 200
    And Response contains value listed in <symbols>
    And Response contains current date
    Examples:
      |endpoint |symbols      |params   |
      |"/latest"|"USD"        |"symbols"|
      |"/latest"|"PLN,GBP"    |"symbols"|
      |"/latest"|"USD,CHF,CAD"|"symbols"|

  @regression, @positive
  Scenario Outline: Requesting all available exchange rates against a specific currency for a current date
    Given User opens ratesapi page
    When User requests <endpoint> using the following <base> as <params>
    Then Request sent. Status code is 200
    And Response contains more than 20 rates against <base>
    And Response contains current date
    Examples:
      |endpoint |base |params|
      |"/latest"|"USD"|"base"|
      |"/latest"|"PLN"|"base"|

  @regression, @positive
  Scenario Outline: Requesting specific exchange rates against  a specific currency for a current date
    Given User opens ratesapi page
    When User requests <endpoint> using the following <base> and <symbols> params
    Then Request sent. Status code is 200
    And Response contains value listed in <symbols>
    And Response contains value listed in <base>
    And Response contains current date
    Examples:
      |endpoint |base |symbols|
      |"/latest"|"USD"|"PLN"  |
      |"/latest"|"PLN"|"GBP"  |

  @negative
  Scenario Outline: Requesting all available exchange rates against default currency with incorrect endpoint

    Given User opens ratesapi page
    When User requests <endpoint>
    Then Request sent. Status code is 400
    And Response contains <error message>

    Examples:
      |endpoint  |error message                                         |
      |"/latestt"|"time data 'latestt' does not match format '%Y-%m-%d'"|

  @negative
  Scenario Outline: Requesting specific exchange rates against default currency with incorrect symbols parameters

    Given User opens ratesapi page
    When User requests <endpoint> using the following <symbols> as <params>
    Then Request sent. Status code is 400
    And Response contains <error message>
    Examples:
      |endpoint |symbols|params    |error message                      |
      |"/latest"|"PL"   |"symbols" |"Symbols 'PL' are invalid for date"|
      |"/latest"|" "    |"symbols" |"Symbols ' ' are invalid for date" |

  @negative
  Scenario Outline: Requesting specific exchange rates against default currency with incorrect base parameters

    Given User opens ratesapi page
    When User requests <endpoint> using the following <base> as <params>
    Then Request sent. Status code is 400
    And Response contains <error message>
    Examples:
      |endpoint |base   |params   |error message                  |
      |"/latest"|"PL"   |"base"   | "Base 'PL' is not supported." |

