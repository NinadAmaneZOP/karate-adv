@timeout @regression @negative
Feature: Connection timeout validation

  Scenario: TMO-NEG-01 - Verify request fails with timeout error
    # Call ping API with 1ms timeout to induce timeout failure
    * def res = call read('classpath:utils/api/booking-query-api.feature@pingWithTimeout') ({ timeoutMs: 1 })
    # Validate timeout error was cleanly caught
    * call read('classpath:utils/validations/timeout-validation.feature@verifyTimeout') ({ actual: res.timeoutResult })
