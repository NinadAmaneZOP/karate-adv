@ignore
Feature: DummyJSON products API calls

  @getProducts
  Scenario: Get products with query parameters
    Given url dummyBaseUrl + paths.products
    And params typeof queryParams === 'undefined' ? {} : queryParams
    When method get

  @getProductsByCategory
  Scenario: Get products by category name
    Given url dummyBaseUrl + paths.products + '/category/' + category
    When method get

  @searchProducts
  Scenario: Search products by keyword
    Given url dummyBaseUrl + paths.products + '/search'
    And param q = query
    When method get
