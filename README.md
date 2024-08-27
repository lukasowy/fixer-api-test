# API Testing Framework

This project is an API testing framework built with Java, Cucumber, and RestAssured, specifically designed to test the Fixer API's Timeseries endpoint.

## Running the Project

### Prerequisites
- Java 21
- Maven

### Setup and Execution

1. **Set Up Your API Key**:
    - Obtain your API key from the [Fixer API website](https://apilayer.com/).
    - Set your API key in the `application.properties` file located in `src/main/resources`. The file should look like this:
      ```properties
      fixer.api.base-url=https://api.apilayer.com/fixer
      fixer.api.key=YOUR_API_KEY
      ```
    - Alternatively, you can set your API key as an environment variable:
      ```bash
      export FIXER_API_KEY=YOUR_API_KEY
      ```

2. **Running Tests**:
    - To run the tests, navigate to the project directory and execute:
      ```bash
      mvn clean test
      ```

