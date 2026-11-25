@ignore
Feature: Auth API operations

  @createToken
  Scenario: Generate auth token
    Given url bookerBaseUrl + paths.auth
    And headers headers.json
    And request authCredentials.admin
    When method post

  @customAuth
  Scenario: Auth with custom credentials
    Given url bookerBaseUrl + paths.auth
    And headers headers.json
    And request credentials
    When method post
