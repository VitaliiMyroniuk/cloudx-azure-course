package com.chtrembl.orderitemsreserver.handler0

import com.chtrembl.orderitemsreserver.config.AppContext
import com.chtrembl.orderitemsreserver.model.Order
import com.chtrembl.orderitemsreserver.service.BlobIntegrationService
import com.fasterxml.jackson.core.JacksonException
import com.fasterxml.jackson.databind.ObjectMapper
import com.microsoft.azure.functions.ExecutionContext
import com.microsoft.azure.functions.HttpMethod.POST
import com.microsoft.azure.functions.HttpRequestMessage
import com.microsoft.azure.functions.HttpResponseMessage
import com.microsoft.azure.functions.HttpStatus.BAD_REQUEST
import com.microsoft.azure.functions.HttpStatus.INTERNAL_SERVER_ERROR
import com.microsoft.azure.functions.HttpStatus.OK
import com.microsoft.azure.functions.annotation.AuthorizationLevel.ANONYMOUS
import com.microsoft.azure.functions.annotation.FunctionName
import com.microsoft.azure.functions.annotation.HttpTrigger
import java.util.logging.Level.SEVERE
import java.util.logging.Level.WARNING

class OrderItemsReserverHandler(
    private val blobIntegrationService: BlobIntegrationService = AppContext.blobIntegrationService(),
    private val objectMapper: ObjectMapper = AppContext.objectMapper()
) {

    @FunctionName("orders")
    fun handle(
        @HttpTrigger(
            name = "request",
            methods = [POST],
            authLevel = ANONYMOUS
        )
        request: HttpRequestMessage<String>,
        context: ExecutionContext
    ): HttpResponseMessage =
        runCatching {
            context.logger.info("Going to handle request: ${request.body}")
            val order = objectMapper.readValue(request.body, Order::class.java)
            blobIntegrationService.upload(order)
            request.createResponseBuilder(OK).build()
        }.getOrElse {
            when (it) {
                is JacksonException,
                is IllegalArgumentException -> {
                    context.logger.log(WARNING, "Failed to handle request: ${request.body}", it)
                    request.createResponseBuilder(BAD_REQUEST).build()
                }

                else -> {
                    context.logger.log(SEVERE, "Failed to handle request: ${request.body}", it)
                    request.createResponseBuilder(INTERNAL_SERVER_ERROR).build()
                }
            }
        }
}
