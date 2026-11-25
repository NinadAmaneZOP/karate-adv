@ignore
Feature: Complex product validations part 2

  @sortedRatingDesc
  Scenario: Ratings are sorted descending
    * def ratings = karate.map(products, function(x){ return x.rating })
    * match utils.isSortedDesc(ratings) == true

  @paginationCheck
  Scenario: Pagination limit and skip
    * match actual.limit == expectedLimit
    * match actual.skip == expectedSkip
    * match karate.sizeOf(actual.products) == expectedLimit

  @selectPruning
  Scenario: Field selection pruning
    * match each products == { id: '#number', title: '#string', price: '#number' }

  @searchRelevance
  Scenario: Search keyword relevance
    * def matches = karate.filter(products, function(x){ return x.title.toLowerCase().includes(keyword) || x.description.toLowerCase().includes(keyword) })
    * match karate.sizeOf(matches) == karate.sizeOf(products)

  @dimensionsCheck
  Scenario: Physical dimensions and weight
    * match each products contains { weight: '#? _ > 0', dimensions: { width: '#? _ > 0', height: '#? _ > 0', depth: '#? _ > 0' } }

  @reviewsCheck
  Scenario: Customer reviews format and rating
    * def allReviews = karate.jsonPath(products, '$..reviews[*]')
    * match each allReviews contains { rating: '#? _ >= 1 && _ <= 5', reviewerEmail: '#regex .+@.+\\..+' }

  @lowStockCheck
  Scenario: Low stock items have status
    * def low = karate.filter(products, function(x){ return x.stock <= 10 })
    * match each low contains { availabilityStatus: '#string' }

  @discountCheck
  Scenario: Discounted price is less than original price
    * def valid = karate.filter(products, function(x){ return x.price * (1 - x.discountPercentage / 100) < x.price })
    * match karate.sizeOf(valid) == karate.sizeOf(products)
