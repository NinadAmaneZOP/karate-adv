@ignore
Feature: Timeout error assertions

  @verifyTimeout
  Scenario: Validate timeout exception
    * match actual.success == false
    * match actual.error == '#regex (?i).*(timeout|timed out).*'
