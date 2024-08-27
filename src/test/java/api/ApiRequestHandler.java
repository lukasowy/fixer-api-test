package api;

import io.restassured.response.Response;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.Optional;

import static java.util.stream.Collectors.toMap;

@Slf4j
@RequiredArgsConstructor
public class ApiRequestHandler {

    private static final int MAX_RETRIES = 10;
    private final RestAssuredApiClient apiClient;

    public Response sendGetRequestWithFilteredParams(String endpoint, Map<String, String> queryParams) {
        Map<String, String> filteredQueryParams = queryParams.entrySet().stream()
                .filter(entry -> entry.getValue() != null && !entry.getValue().isEmpty())
                .collect(toMap(Map.Entry::getKey, Map.Entry::getValue));

        return apiClient.sendGetRequest(endpoint, filteredQueryParams);
    }

    public void sendMultipleRequests(String endpoint, Map<String, String> queryParams) {
        Response response = apiClient.sendGetRequest(endpoint, queryParams);

        final int[] nullCount = {0};
        int remainingLimit = Optional.ofNullable(response.getHeader("RateLimit-Remaining"))
                .map(Integer::parseInt)
                .orElse(Integer.MAX_VALUE);

        for (int i = 0; i < remainingLimit; i++) {
            response = apiClient.sendGetRequest("/timeseries", queryParams);

            if (response.statusCode() == 429) {
                log.info("Rate limit exceeded after {} requests.", i);
                break;
            }

            remainingLimit = Optional.ofNullable(response.getHeader("RateLimit-Remaining"))
                    .map(Integer::parseInt)
                    .orElseGet(() -> {
                        nullCount[0]++;
                        log.warn("RateLimit-Remaining header was null {} times.", nullCount[0]);
                        return Integer.MAX_VALUE;
                    });

            log.info("Remaining limit: {}", remainingLimit);

            if (nullCount[0] >= MAX_RETRIES) {
                log.error("RateLimit-Remaining header was null {} times. Max retries reached. Stopping test.", nullCount[0]);
                break;
            }
        }


    }
}
