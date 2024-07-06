package com.chtrembl.orderitemsreserver.service

import com.azure.storage.blob.BlobServiceClient
import com.chtrembl.orderitemsreserver.model.Order
import com.fasterxml.jackson.databind.ObjectMapper

class BlobIntegrationService(
    private val blobServiceClient: BlobServiceClient,
    private val objectMapper: ObjectMapper
) {

    fun upload(order: Order) {
        val orderJSON = objectMapper.writeValueAsString(order)
        blobServiceClient
            .getBlobContainerClient(System.getenv("AZURE_STORAGE_ORDERS_CONTAINER"))
            .getBlobClient("${order.id}.json")
            .upload(orderJSON.byteInputStream())
    }
}
