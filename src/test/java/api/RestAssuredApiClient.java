package api;

import config.ApiConfiguration;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import lombok.RequiredArgsConstructor;

import java.util.Map;

@RequiredArgsConstructor
public class RestAssuredApiClient {

    private final ApiConfiguration apiConfiguration;

    public Response sendGetRequest(String endpoint, Map<String, String> queryParams) {
        var requestSpec = RestAssured.given()
                .baseUri(apiConfiguration.getBaseUrl())
                .basePath(endpoint)
                .queryParams(queryParams)
                .log().all();

        if (apiConfiguration.getApiKey() != null) {
            requestSpec.header("apikey", apiConfiguration.getApiKey());
        }

        return requestSpec
                .when()
                .get()
                .then()
                .log().ifError()
                .extract().response();
    }
}
