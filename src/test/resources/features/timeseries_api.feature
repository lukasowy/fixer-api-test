@fixer @timeseries
Feature: Fixer API Timeseries Endpoint

  Background:
    Given a valid API key is provided

  @positive @status200
  Scenario Outline: Retrieve timeseries data with valid parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date   | end_date   | base   | symbols   |
      | <start_date> | <end_date> | <base> | <symbols> |
    Then the API response should have status code 200

    Examples:
      | start_date | end_date   | base | symbols     | # Scenario Description
      | 2023-01-01 | 2023-01-10 |      |             | # Only required parameters
      | 2023-01-01 | 2023-01-10 | EUR  | USD         | # All parameters provided
      | 2023-01-01 | 2023-01-10 | EUR  |             | # Without specifying symbols
      | 2023-01-01 | 2023-01-10 |      | USD         | # Without specifying base
      | 2023-01-01 | 2023-01-10 | EUR  | USD,GBP,JPY | # Multiple symbols
      | 2022-01-01 | 2023-01-01 | EUR  | USD         | # Date range equals 365 days

  @negative @status400
  Scenario Outline: Handle invalid parameters when requesting timeseries data
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date   | end_date   | base   | symbols   |
      | <start_date> | <end_date> | <base> | <symbols> |
    Then the API response should have status code 400

    Examples:
      | start_date | end_date   | base | symbols | # Scenario Description
      |            | 2023-01-10 |      |         | # Missing required parameters
      | 01-01-2023 | 10-01-2023 |      |         | # Invalid date format
      | 2023-01-01 | 2023-01-10 | @#$% | ^&*()   | # Special characters in parameters
      | 2023-01-10 | 2023-01-01 | EUR  | USD     | # Overlapping date range
      | 2021-01-01 | 2023-01-01 |      |         | # Date range exceeding 365 days
      | 2023-01-01 | 2023-01-10 | EUR  | INVALID | # Mixed valid and invalid parameters
      |            |            |      |         | # No parameters

  @negative @status401
  Scenario: Reject request with an invalid API key
    Given an invalid API key is provided
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 2023-01-01 | 2023-01-10 |
    Then the API response should have status code 401

  @negative @status401
  Scenario: Reject request without an API key
    Given no API key is provided
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   | base | symbols |
      | 2023-01-01 | 2023-01-10 | EUR  | USD     |
    Then the API response should have status code 401

  @ignore @negative @status403
  Scenario: Access timeseries endpoint after subscription cancellation
    # This test should be run manually after the subscription is canceled or create a separate account without subscription.
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 2023-01-01 | 2023-01-10 |
    Then the API response should have status code 403

  @negative @status404
  Scenario: Request timeseries data for future dates
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 2025-01-01 | 2025-01-11 |
    Then the API response should have status code 404

  @ignore @negative @status429
  Scenario: Exceed API rate limit and receive a 429 response
    # This test should be run separately to avoid consuming all the API requests.
    When GET requests are sent until the rate limit is reached with the following parameters:
      | start_date | end_date   |
      | 2023-01-01 | 2023-01-10 |
    Then the API response should have status code 429
