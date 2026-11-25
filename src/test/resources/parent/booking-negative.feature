@regression @negative @edge
Feature: Booking negative and edge scenarios

  Scenario: NEG-01 - Bad credentials on auth endpoint
    * def res = call read('classpath:utils/api/auth-api.feature@customAuth') ({ credentials: authCredentials.bad })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: 200 })
    * call read('classpath:utils/validations/common-validation.feature@contains') ({ actual: res.response, expected: { reason: 'Bad credentials' } })

  Scenario Outline: <caseId> - Unauthorized <description>
    # Create booking to obtain target ID
    * def createRes = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: testData.getBookingPayload() })
    * def targetId = createRes.response.bookingid
    # Call endpoint without valid token
    * def res = call read('classpath:utils/api/booking-query-api.feature@customTokenRequest') ({ id: targetId, httpMethod: '<method>', tokenHeader: '<tokenHeader>', payload: testData.getBookingPayload() })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: '<expectedStatus>' })

    Examples:
      | read('classpath:utils/data/auth-negative-cases.csv') |

  Scenario Outline: <caseId> - <description>
    # Malformed payload missing required field
    * def malformedPayload = edgeData.getMalformedPayload('<missingField>')
    * def res = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: malformedPayload })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: '<expectedStatus>' })

    Examples:
      | read('classpath:utils/data/booking-missing-field-cases.csv') |

  Scenario Outline: <caseId> - <description>
    # Non-existent or invalid ID
    * def res = call read('classpath:utils/api/booking-api.feature@getBooking') ({ id: '<targetId>' })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: '<expectedStatus>' })

    Examples:
      | read('classpath:utils/data/booking-negative-cases.csv') |

  Scenario Outline: <caseId> - <description>
    # Boundary edge inputs
    * def edgePayload = edgeData.getEdgePayload('<fieldCase>')
    * def res = call read('classpath:utils/api/booking-api.feature@createBooking') ({ payload: edgePayload })
    * call read('classpath:utils/validations/common-validation.feature@status') ({ actualStatus: res.responseStatus, expectedStatus: '<expectedStatus>' })

    Examples:
      | read('classpath:utils/data/booking-edge-cases.csv') |
