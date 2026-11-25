@regression @positive
Feature: DummyJSON complex product validations

  Background:
    * def api = 'classpath:utils/api/product-api.feature'
    * def v1 = 'classpath:utils/validations/complex-product-validation.feature'
    * def v2 = 'classpath:utils/validations/complex-filter-validation.feature'

  Scenario: VAL-01 - Filter high-rated products (rating >= 4.0)
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v1 + '@highRatings') ({ products: res.response.products })

  Scenario: VAL-02 - Expensive products have positive stock
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v1 + '@expensiveStock') ({ products: res.response.products })

  Scenario: VAL-03 - Every rating is between 0 and 5
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v1 + '@ratingBounds') ({ products: res.response.products })

  Scenario: VAL-04 - All product IDs are unique
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v1 + '@uniqueIds') ({ products: res.response.products })

  Scenario: VAL-05 - Sum of prices matches computed total
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v1 + '@priceSum') ({ products: res.response.products })

  Scenario: VAL-06 - Category scoping
    * def res = call read(api + '@getProductsByCategory') ({ category: utils.getCategoryName() })
    * call read(v1 + '@categoryCheck') ({ products: res.response.products, expectedCategory: utils.getCategoryName() })

  Scenario: VAL-07 - Ascending price sort order
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getSortedParams() })
    * call read(v1 + '@sortedPriceAsc') ({ products: res.response.products })

  Scenario: VAL-08 - Descending rating sort order
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getSortedRatingDescParams() })
    * call read(v2 + '@sortedRatingDesc') ({ products: res.response.products })

  Scenario: VAL-09 - Pagination limit and skip
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getPaginationParams() })
    * call read(v2 + '@paginationCheck') ({ actual: res.response, expectedLimit: 5, expectedSkip: 10 })

  Scenario: VAL-10 - Field selection pruning
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getSelectParams() })
    * call read(v2 + '@selectPruning') ({ products: res.response.products })

  Scenario: VAL-11 - Search keyword relevance
    * def res = call read(api + '@searchProducts') ({ query: 'phone' })
    * call read(v2 + '@searchRelevance') ({ products: res.response.products, keyword: 'phone' })

  Scenario: VAL-12 - Physical dimensions and weight
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v2 + '@dimensionsCheck') ({ products: res.response.products })

  Scenario: VAL-13 - Customer reviews integrity
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v2 + '@reviewsCheck') ({ products: res.response.products })

  Scenario: VAL-14 - Low stock alert inventory
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v2 + '@lowStockCheck') ({ products: res.response.products })

  Scenario: VAL-15 - Discounted price calculation
    * def res = call read(api + '@getProducts') ({ queryParams: utils.getProductParams() })
    * call read(v2 + '@discountCheck') ({ products: res.response.products })
