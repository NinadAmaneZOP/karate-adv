@ignore
Feature: Complex product validations part 1

  @highRatings
  Scenario: Filter ratings >= 4.0 and validate
    * def highRated = karate.filter(products, function(x){ return x.rating >= 4.0 })
    * assert karate.sizeOf(highRated) > 0
    * match each highRated contains { rating: '#? _ >= 4.0' }

  @expensiveStock
  Scenario: Products with price > 100 have positive stock
    * def expensive = karate.jsonPath(products, '$[?(@.price > 100)]')
    * match each expensive contains { stock: '#? _ > 0' }

  @ratingBounds
  Scenario: Every rating is between 0 and 5
    * def invalid = karate.filter(products, function(x){ return x.rating < 0 || x.rating > 5 })
    * match invalid == []
    * match each products contains { rating: '#? _ >= 0 && _ <= 5' }

  @uniqueIds
  Scenario: All product IDs are unique
    * def ids = karate.map(products, function(x){ return x.id })
    * match utils.isUnique(ids) == true

  @priceSum
  Scenario: Sum of prices matches computed total
    * def prices = karate.map(products, function(x){ return x.price })
    * def computed = Math.round(utils.sum(prices) * 100) / 100
    * def loopSum = 0
    * karate.forEach(prices, function(p){ loopSum = loopSum + p })
    * match computed == Math.round(loopSum * 100) / 100

  @categoryCheck
  Scenario: Category scoping matches expected
    * match each products contains { category: '#(expectedCategory)' }

  @sortedPriceAsc
  Scenario: Prices are sorted ascending
    * def values = karate.map(products, function(x){ return x.price })
    * match utils.isSortedAsc(values) == true
