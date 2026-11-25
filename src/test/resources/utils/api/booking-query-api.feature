@ignore
Feature: Booking query and specialized API calls

  @ping
  Scenario: Ping healthcheck
    Given url bookerBaseUrl + paths.ping
    When method get

  @getBookingIds
  Scenario: Query booking IDs with optional filters
    Given url bookerBaseUrl + paths.booking
    And params typeof queryParams === 'undefined' ? {} : queryParams
    When method get

  @customPutRequest
  Scenario: PUT request with custom or omitted token
    Given url bookerBaseUrl + paths.booking + '/' + id
    And headers headers.json
    * def tokenCookie = tokenHeader != 'none' ? ('token=' + tokenHeader) : null
    And header Cookie = tokenCookie
    And request payload
    When method put

  @customDeleteRequest
  Scenario: DELETE request with custom or omitted token
    Given url bookerBaseUrl + paths.booking + '/' + id
    * def tokenCookie = tokenHeader != 'none' ? ('token=' + tokenHeader) : null
    And header Cookie = tokenCookie
    When method delete

  @customTokenRequest
  Scenario: Router for custom token requests
    * def targetTag = httpMethod == 'PUT' ? '@customPutRequest' : '@customDeleteRequest'
    * def callResult = karate.call('classpath:utils/api/booking-query-api.feature' + targetTag, { id: id, tokenHeader: tokenHeader, payload: payload })
    * def responseStatus = callResult.responseStatus
    * def response = callResult.response

  @pingWithTimeout
  Scenario: Ping with custom timeout
    * configure connectTimeout = timeoutMs
    * configure readTimeout = timeoutMs
    * def callPing = function() { try { return { success: true, res: karate.call('classpath:utils/api/booking-query-api.feature@ping') }; } catch(e) { return { success: false, error: e.message }; } }
    * def timeoutResult = callPing()
