@smoke @regression @positive
Feature: Restful-Booker main operations

  Background:
    # Obtain auth token once for the feature
    * def authRes = callonce read('classpath:utils/api/auth-api.feature@createToken')
    * def token = authRes.response.token

  Scenario: BKG-01 - Ping healthcheck
    # Verify healthcheck endpoint is up
    * def res = call read('classpath:utils/api/booking-query-api.feature@ping')
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: 201 })

  Scenario: BKG-02 - Complete booking lifecycle with token chaining
    # Create booking
    * def createRes = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: testData.getBookingPayload() })
    * def id = createRes.response.bookingid
    * call read('classpath:utils/validations/booking-validation.feature@bookingCreated') ({ actualStatus: createRes.responseStatus, actual: createRes.response })
    # Retrieve booking details
    * def getRes = call read('classpath:utils/api/booking-api.feature@getBooking') ({ id: id })
    * call read('classpath:utils/validations/booking-validation.feature@bookingMatches') ({ actualStatus: getRes.responseStatus, actual: getRes.response, expected: createRes.response.booking })
    # Update via PUT with token
    * def putRes = call read('classpath:utils/api/booking-api.feature@updateBooking') ({ id: id, authToken: token, payload: testData.getBookingPayload() })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: putRes.responseStatus, expectedStatus: 200 })
    # Partial update via PATCH with token
    * def patchRes = call read('classpath:utils/api/booking-api.feature@patchBooking') ({ id: id, authToken: token, payload: testData.getPartialPayload() })
    * call read('classpath:utils/validations/common-validation.feature@contains') ({ actual: patchRes.response, expected: testData.getPartialPayload() })
    # Delete booking with token
    * def delRes = call read('classpath:utils/api/booking-api.feature@deleteBooking') ({ id: id, authToken: token })
    * call read('classpath:utils/validations/booking-validation.feature@bookingDeleted') ({ actualStatus: delRes.responseStatus, actual: delRes.response })

  Scenario: BKG-03 - Booking with and without optional additionalneeds
    # Create without additionalneeds then add via PATCH
    * def createRes = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: testData.getBookingPayload({ includeNeeds: false }) })
    * def id = createRes.response.bookingid
    * def patchRes = call read('classpath:utils/api/booking-api.feature@patchBooking') ({ id: id, authToken: token, payload: testData.getPatchPayload() })
    * call read('classpath:utils/validations/common-validation.feature@contains') ({ actual: patchRes.response, expected: testData.getPatchPayload() })

  Scenario: BKG-04 - Empty field handling and update persistence
    # Create with empty firstname
    * def createRes = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: testData.getEmptyFieldPayload() })
    * def id = createRes.response.bookingid
    # Update with token and verify persistence
    * def patchRes = call read('classpath:utils/api/booking-api.feature@patchBooking') ({ id: id, authToken: token, payload: testData.getPartialPayload() })
    * def getRes = call read('classpath:utils/api/booking-api.feature@getBooking') ({ id: id })
    * call read('classpath:utils/validations/common-validation.feature@contains') ({ actual: getRes.response, expected: testData.getPartialPayload() })
