package config;

public class ApiConfiguration {

    private ApiKey apiKey;
    private BaseUrl baseUrl;

    public String getBaseUrl() {
        return baseUrl.url();
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = new BaseUrl(baseUrl);
    }

    public String getApiKey() {
        return apiKey.key();
    }

    public void setApiKey(String apiKey) {
        this.apiKey = new ApiKey(apiKey);
    }

    public record ApiKey(String key) {}

    public record BaseUrl(String url) {}
}
