@fixer @timeseries
Feature: Fixer API Timeseries Endpoint

  Background:
    Given a valid API key is provided

  @positive @status200
  Scenario: Retrieve timeseries data with only required parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 2023-01-01 | 2023-01-10 |
    Then the API response should have status code 200

  @positive @status200
  Scenario: Retrieve timeseries data with all parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   | base | symbols |
      | 2023-01-01 | 2023-01-10 | EUR  | USD     |
    Then the API response should have status code 200

  @negative @status400
  Scenario: Request timeseries data with missing required parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | end_date   |
      | 2023-01-10 |
    Then the API response should have status code 400

  @negative @status400
  Scenario: Request timeseries data with invalid date format
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   |
      | 01-01-2023 | 10-01-2023 |
    Then the API response should have status code 400

  @negative @status400
  Scenario: Request timeseries data with special characters in parameters
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   | base | symbols |
      | 2023-01-01 | 2023-01-10 | @#$% | ^&*()   |
    Then the API response should have status code 400

  @negative @status400
  Scenario: Request timeseries data with overlapping date range
    When a GET request is sent to the timeseries endpoint with the following parameters:
      | start_date | end_date   | base | symbols |
      | 2023-01-10 | 2023-01-01 | EUR  | USD     |
    Then the API response should have status code 400

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

