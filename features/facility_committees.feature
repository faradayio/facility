Feature: Facility Committee Calculations
  The facility model should generate correct committee calculations

  Background:
    Given a facility

  Scenario: eGRID subregion commitee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

  Scenario Outline: eGRID region committee from default
    When the "egrid_region" committee reports
    Then the committee should have used quorum "from default"
    And the conclusion of the committee should have "name" of "US"

  Scenario Outline: eGRID region committee eGRID subregion
    Given a characteristic "egrid_subregion.abbreviation" of "<subregion>"
    When the "egrid_region" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should have "name" of "<name>"
    Examples:
      | subregion | name |
      | SRVC      | E    |
      | CAMX      | W    |
