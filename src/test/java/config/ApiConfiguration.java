package config;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class ApiConfiguration {

    private ApiKey apiKey;
    private BaseUrl baseUrl;

    public String getBaseUrl() {
        return baseUrl.getUrl();
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = new BaseUrl(baseUrl);
    }

    public String getApiKey() {
        return apiKey.getKey();
    }

    public void setApiKey(String apiKey) {
        this.apiKey = new ApiKey(apiKey);
    }

    @Getter
    @RequiredArgsConstructor
    public static class ApiKey {
        private final String key;
    }

    @Getter
    @RequiredArgsConstructor
    public static class BaseUrl {
        private final String url;
    }
}
