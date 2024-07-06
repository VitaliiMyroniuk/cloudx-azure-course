package com.chtrembl.orderitemsreserver.config

import com.azure.identity.DefaultAzureCredentialBuilder
import com.azure.storage.blob.BlobServiceClient
import com.azure.storage.blob.BlobServiceClientBuilder
import com.azure.storage.common.policy.RequestRetryOptions
import com.azure.storage.common.policy.RetryPolicyType
import com.chtrembl.orderitemsreserver.service.BlobIntegrationService
import com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import java.text.SimpleDateFormat
import java.util.TimeZone

class AppContext {

    companion object {

        fun objectMapper(): ObjectMapper = jacksonObjectMapper()
            .setDateFormat(SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX"))
            .setTimeZone(TimeZone.getTimeZone("UTC"))
            .configure(FAIL_ON_UNKNOWN_PROPERTIES, false)
            .registerModule(JavaTimeModule())

        fun blobIntegrationService() = BlobIntegrationService(
            blobServiceClient(),
            objectMapper()
        )

        private fun blobServiceClient(): BlobServiceClient =
            System.getenv("AZURE_STORAGE_CONNECTION_STRING")?.let {
                BlobServiceClientBuilder()
                    .connectionString(it)
                    .retryOptions(blobRequestRetryOptions())
                    .buildClient()
            } ?: BlobServiceClientBuilder()
                .endpoint(System.getenv("AZURE_STORAGE_ENDPOINT"))
                .credential(DefaultAzureCredentialBuilder().build())
                .retryOptions(blobRequestRetryOptions())
                .buildClient()

        private fun blobRequestRetryOptions() = RequestRetryOptions(
            RetryPolicyType.EXPONENTIAL,
            System.getenv("AZURE_STORAGE_MAX_RETRIES")?.toInt(),
            System.getenv("AZURE_STORAGE_RETRY_TIMEOUT_SEC")?.toInt(),
            System.getenv("AZURE_STORAGE_RETRY_DELAY_MS")?.toLong(),
            System.getenv("AZURE_STORAGE_MAX_RETRY_DELAY_MS")?.toLong(),
            System.getenv("AZURE_STORAGE_SECONDARY_HOST")
        )
    }
}
