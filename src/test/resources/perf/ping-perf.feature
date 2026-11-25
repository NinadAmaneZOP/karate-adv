Feature: Ping performance check (local mock)

  Scenario: Call ping endpoint (reuses existing API helper)
    # Reuse the existing ping API helper feature
    * def result = call read('classpath:utils/api/booking-query-api.feature@ping')
    # Validate the response status (Restful-Booker ping returns 201)
    Then match result.responseStatus == 201
