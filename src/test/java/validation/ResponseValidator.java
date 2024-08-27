package validation;

import io.restassured.response.Response;

public class ResponseValidator {

    public void validateStatusCode(Response response, Integer expectedStatusCode) {
        response.then().statusCode(expectedStatusCode);
    }
}
