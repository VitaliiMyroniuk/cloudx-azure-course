repositories {
    mavenLocal()
    mavenCentral()
}

plugins {
    kotlin("jvm") version "1.9.24"
    id("com.microsoft.azure.azurefunctions") version "1.8.0"
}

group = "com.chtrembl"
version = "1.0.0-SNAPSHOT"

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.17.1")
    implementation("com.microsoft.azure.functions:azure-functions-java-library:3.1.0")
    implementation("com.azure:azure-storage-blob:12.26.1")
    implementation("com.azure:azure-identity:1.13.0")
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

kotlin {
    compilerOptions {
        freeCompilerArgs.addAll("-Xjsr305=strict")
    }
}

azurefunctions {
    appName = "petstore-order-items-reserver"
    region = "eastus"
    pricingTier = "Consumption"
    resourceGroup = "petstore-temp"
    appServicePlanName = "petstore-order-items-reserver"
    appInsightsInstance = "petstore-app-insights-eastus"
    localDebug = "transport=dt_socket,server=y,suspend=n,address=5005"

    setRuntime(closureOf<com.microsoft.azure.gradle.configuration.GradleRuntimeConfig> {
        os("Linux")
        javaVersion("21")
    })
    setAppSettings(closureOf<MutableMap<String, String>> {
        put("FUNCTIONS_EXTENSION_VERSION", "~4")
        put("AZURE_STORAGE_ORDERS_CONTAINER", "orders")
        put("AZURE_STORAGE_ENDPOINT", "https://petstorestorage.blob.core.windows.net")
        put("AZURE_STORAGE_MAX_RETRIES", "2")
        put("AZURE_STORAGE_RETRY_TIMEOUT_SEC", "5")
    })
    setAuth(closureOf<com.microsoft.azure.gradle.auth.GradleAuthConfig> {
        type = "azure_cli"
    })
    setDeployment(closureOf<com.microsoft.azure.plugin.functions.gradle.configuration.deploy.Deployment> {
        type = "run_from_blob"
    })
}

tasks.withType<Test> {
    useJUnitPlatform()
}
