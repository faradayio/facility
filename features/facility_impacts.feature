Feature: Facility Impacts Calculations
  The facility model should generate correct impact calculations

  Background:
    Given a facility

  Scenario: Calculations from default
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "91.96"
