@ignore
Feature: Timeout error assertions

  @verifyTimeout
  Scenario: Validate timeout exception
    * match actual.success == false
    * match actual.error == '#regex (?is).*(timeout|timed out).*'
