@load @stress
Feature: API load and stress validation

  Scenario Outline: LOAD-PING-<i> - Restful-Booker ping under concurrent load
    Given url bookerBaseUrl + paths.ping
    When method get
    Then status 201

    Examples:
      | i  |
      | 01 |
      | 02 |
      | 03 |
      | 04 |
      | 05 |
      | 06 |
      | 07 |
      | 08 |
      | 09 |
      | 10 |

  Scenario Outline: LOAD-PRODUCTS-<i> - DummyJSON products list under concurrent load
    Given url dummyBaseUrl + paths.products
    And params { limit: 10 }
    When method get
    Then status 200
    And match response.products == '#[10]'
    And match response.total == '#number'

    Examples:
      | i  |
      | 01 |
      | 02 |
      | 03 |
      | 04 |
      | 05 |
      | 06 |
      | 07 |
      | 08 |
      | 09 |
      | 10 |

  Scenario Outline: LOAD-SEARCH-<i> - DummyJSON product search under concurrent load
    Given url dummyBaseUrl + paths.products + '/search'
    And param q = 'phone'
    When method get
    Then status 200
    And match response.products == '#[]'
    And match response.total == '#number'

    Examples:
      | i  |
      | 01 |
      | 02 |
      | 03 |
      | 04 |
      | 05 |
      | 06 |
      | 07 |
      | 08 |
      | 09 |
      | 10 |
