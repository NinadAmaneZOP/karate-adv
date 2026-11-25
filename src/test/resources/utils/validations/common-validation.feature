@ignore
Feature: Reusable common assertions

  @status
  Scenario: Validate HTTP status code
    * match actualStatus == Number(expectedStatus)

  @equals
  Scenario: Validate exact value equality
    * match actual == expected

  @contains
  Scenario: Validate payload contains expected fields
    * match actual contains expected
