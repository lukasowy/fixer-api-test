package config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;
import java.util.Properties;

public class ConfigurationLoader {

    private final Properties properties = new Properties();

    public ConfigurationLoader() {
        loadProperties();
    }

    private void loadProperties() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new RuntimeException("Sorry, unable to find application.properties");
            }
            properties.load(input);
        } catch (IOException ex) {
            throw new RuntimeException("Failed to load properties file", ex);
        }
    }

    public String getApiKey() {
        return Optional.ofNullable(properties.getProperty("fixer.api.key"))
                .orElseGet(() -> System.getenv("FIXER_API_KEY"));
    }

    public String getBaseUrl() {
        return properties.getProperty("fixer.api.base-url");
    }
}
