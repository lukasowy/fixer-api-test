@fixer @timeseries
Feature: Fixer API Timeseries Endpoint

  Background:
    Given a valid API key is provided

  @positive @status200
  Scenario Outline: Retrieve timeseries data with different combinations of parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date   | end_date   | base   | symbols   |
      | <start_date> | <end_date> | <base> | <symbols> |
    Then the API response should have status code 200

    Examples:
      | start_date | end_date   | base | symbols |
    # Only required parameters
      | 2023-01-01 | 2023-01-10 |      |         |
    # All parameters provided
      | 2023-01-01 | 2023-01-10 | EUR  | USD     |
    # Without specifying symbols
      | 2023-01-01 | 2023-01-10 | EUR  |         |
    # Without specifying base
      | 2023-01-01 | 2023-01-10 |      | USD     |
    # With multiple symbols
      | 2023-01-01 | 2023-01-10 | EUR  | USD,GBP,JPY |
    # Date range equals 365 days
      | 2022-01-01 | 2023-01-01 | EUR  | USD     |

  @negative @status400
  Scenario Outline: Request timeseries data with invalid parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date   | end_date   | base   | symbols   |
      | <start_date> | <end_date> | <base> | <symbols> |
    Then the API response should have status code 400

    Examples:
      | start_date | end_date   | base | symbols |
    # Missing required parameters
      |            | 2023-01-10 |      |         |
    # Invalid date format
      | 01-01-2023 | 10-01-2023 |      |         |
    # Special characters in parameters
      | 2023-01-01 | 2023-01-10 | @#$% | ^&*()   |
    # Overlapping date range
      | 2023-01-10 | 2023-01-01 | EUR  | USD     |
    # Date range exceeding 365 days
      | 2021-01-01 | 2023-01-01 |      |         |
    # Mixed valid and invalid parameters
      | 2023-01-01 | 2023-01-10 | EUR  | INVALID |
    # No parameters
      |            |          |      |         |

  @negative @status401
  Scenario: Request timeseries data with an invalid API key
    Given an invalid API key is provided
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 2023-01-01 | 2023-01-10 |
    Then the API response should have status code 401

  @negative @status401
  Scenario: Request timeseries data without an API key
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

