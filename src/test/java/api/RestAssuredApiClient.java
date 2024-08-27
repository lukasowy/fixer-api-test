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
        return RestAssured.given()
                .baseUri(apiConfiguration.getBaseUrl())
                .when()
                .basePath(endpoint)
                .queryParams(queryParams)
                .log().all()
                .header("apikey", apiConfiguration.getApiKey())
                .get()
                .then()
                .log().everything()
                .extract().response();
    }
}
