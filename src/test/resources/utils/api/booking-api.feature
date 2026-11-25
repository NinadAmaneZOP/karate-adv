@ignore
Feature: Booking CRUD API operations

  @createBooking
  Scenario: Create a new booking
    Given url bookerBaseUrl + paths.booking
    And headers headers.json
    And request payload
    When method post

  @getBooking
  Scenario: Get booking by ID
    Given url bookerBaseUrl + paths.booking + '/' + id
    And headers headers.acceptJson
    When method get

  @updateBooking
  Scenario: Update booking via PUT
    Given url bookerBaseUrl + paths.booking + '/' + id
    And headers headers.json
    And header Cookie = 'token=' + authToken
    And request payload
    When method put

  @patchBooking
  Scenario: Partial update via PATCH
    Given url bookerBaseUrl + paths.booking + '/' + id
    And headers headers.json
    And header Cookie = 'token=' + authToken
    And request payload
    When method patch

  @deleteBooking
  Scenario: Delete booking via DELETE
    Given url bookerBaseUrl + paths.booking + '/' + id
    And header Cookie = 'token=' + authToken
    When method delete
