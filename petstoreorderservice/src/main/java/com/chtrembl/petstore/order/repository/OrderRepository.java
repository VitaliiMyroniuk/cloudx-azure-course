package com.chtrembl.petstore.order.repository;

import com.azure.spring.data.cosmos.repository.CosmosRepository;
import com.chtrembl.petstore.order.model.Order;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Repository;

@Repository
@ConditionalOnProperty(name = "spring.cloud.azure.cosmos.enabled", havingValue = "true")
public interface OrderRepository extends CosmosRepository<Order, String> {
}
