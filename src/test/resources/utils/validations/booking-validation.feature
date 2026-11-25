@ignore
Feature: Booking assertions

  @bookingCreated
  Scenario: Validate booking creation response
    * def schema = read('classpath:utils/data/booking-schema.json')
    * match actualStatus == 200
    * match actual.bookingid == '#number'
    * match actual.booking == schema

  @bookingMatches
  Scenario: Validate booking response content
    * def schema = read('classpath:utils/data/booking-schema.json')
    * match actualStatus == 200
    * match actual == schema
    * match actual contains expected

  @bookingDeleted
  Scenario: Validate booking deletion response
    # Restful-Booker returns 201 Created on DELETE
    * match actualStatus == 201
    * match actual == 'Created'

  @bookingIdsList
  Scenario: Validate booking ID search list
    * match actualStatus == 200
    * match actual == '#[]'
    * match each actual == { bookingid: '#number' }
