package config;

public class ApiConfigurationManager {

    private final ConfigurationLoader configurationLoader;
    private final ApiConfiguration apiConfiguration;

    public ApiConfigurationManager(ConfigurationLoader configurationLoader, ApiConfiguration apiConfiguration) {
        this.configurationLoader = configurationLoader;
        this.apiConfiguration = apiConfiguration;
    }

    public void initializeApiConfiguration() {
        apiConfiguration.setBaseUrl(configurationLoader.getBaseUrl());
        apiConfiguration.setApiKey(configurationLoader.getApiKey());
    }

    public void setValidApiKey() {
        apiConfiguration.setApiKey(configurationLoader.getApiKey());
    }

    public void setInvalidApiKey() {
        apiConfiguration.setApiKey("INVALID_API_KEY");
    }

    public void clearApiKey() {
        apiConfiguration.setApiKey(null);
    }
}
