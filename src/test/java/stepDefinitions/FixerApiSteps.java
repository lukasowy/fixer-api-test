package stepDefinitions;

import api.ApiRequestHandler;
import config.ApiConfigurationManager;
import io.cucumber.datatable.DataTable;
import io.cucumber.java8.En;
import io.restassured.response.Response;
import lombok.extern.slf4j.Slf4j;
import validation.ResponseValidator;

import java.util.List;
import java.util.Map;

@Slf4j
public class FixerApiSteps implements En {

    private final ApiRequestHandler apiRequestHandler;
    private final ApiConfigurationManager apiConfigManager;
    private final ResponseValidator responseValidator;
    private Response response;

    public FixerApiSteps(ApiRequestHandler apiRequestHandler, ApiConfigurationManager apiConfigManager, ResponseValidator responseValidator) {
        this.apiRequestHandler = apiRequestHandler;
        this.apiConfigManager = apiConfigManager;
        this.responseValidator = responseValidator;

        setupSteps();
    }

    private void setupSteps() {
        Before(apiConfigManager::initializeApiConfiguration);

        Given("a valid API key is provided", apiConfigManager::setValidApiKey);

        Given("no API key is provided", apiConfigManager::clearApiKey);

        Given("an invalid API key is provided", apiConfigManager::setInvalidApiKey);

        When("a GET request is sent to the timeseries endpoint with the following parameters:", this::handleGetRequestWithParams);

        When("GET requests are sent until the rate limit is reached with the following parameters:", this::handleMultipleRequests);

        Then("the API response should have status code {int}", this::checkResponseStatusCode);
    }

    private void handleGetRequestWithParams(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);
        Map<String, String> queryParams = rows.get(0);
        response = apiRequestHandler.sendGetRequest("/timeseries", queryParams);
    }

    private void handleMultipleRequests(DataTable dataTable) {
        List<Map<String, String>> rows = dataTable.asMaps(String.class, String.class);
        Map<String, String> queryParams = rows.get(0);
        apiRequestHandler.sendMultipleRequests("/timeseries", queryParams);
    }

    private void checkResponseStatusCode(Integer expectedStatusCode) {
        responseValidator.validateStatusCode(response, expectedStatusCode);
    }
}
