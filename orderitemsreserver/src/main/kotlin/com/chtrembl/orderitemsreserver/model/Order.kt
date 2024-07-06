package com.chtrembl.orderitemsreserver.model

import com.fasterxml.jackson.annotation.JsonValue
import java.time.OffsetDateTime

data class Order(
    val id: String,
    val email: String,
    val products: List<Product>,
    val shipDate: OffsetDateTime?,
    val status: OrderStatus,
    val complete: Boolean
)

data class Product(
    val id: Long,
    val quantity: Int,
    val name: String?,
    val photoURL: String?,
    val tags: List<Tag>?
)

data class Tag(
    val id: Long,
    val name: String
)

enum class OrderStatus(
    @JsonValue
    val value: String
) {
    PLACED("placed"),
    APPROVED("approved"),
    DELIVERED("delivered")
}
