package com.chtrembl.petstore.order.service;

import com.azure.messaging.servicebus.ServiceBusMessage;
import com.azure.messaging.servicebus.ServiceBusSenderAsyncClient;
import com.chtrembl.petstore.order.model.Order;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import static java.lang.String.format;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class OrderItemsReserverService {

    private static final Logger log = LoggerFactory.getLogger(OrderItemsReserverService.class);

    @Value("${petstore.service.order-items-reserver.url}")
    private String petstoreOrderItemsReserverURL;
    @Autowired
    private RestTemplate restTemplate;
    @Autowired
    private ServiceBusSenderAsyncClient serviceBusSenderClient;
    @Autowired
    private ObjectMapper objectMapper;

    public void placeOrder(Order order) {
        log.info("Going to reserve order {}", order);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", MediaType.APPLICATION_JSON_VALUE);
        headers.add("Accept", MediaType.APPLICATION_JSON_VALUE);
        headers.add("session-id", "PetStoreOrderService");
        HttpEntity<Order> entity = new HttpEntity<>(order, headers);
        restTemplate.postForObject(format("%s/api/orders", petstoreOrderItemsReserverURL), entity, Order.class);
    }

    public void publishOrderAsync(Order order) throws JsonProcessingException {
        log.info("Going to publish order {}", order);
        String orderJson = objectMapper.writeValueAsString(order);
        ServiceBusMessage message = new ServiceBusMessage(orderJson);
        serviceBusSenderClient.sendMessage(message)
                              .doOnError(error -> log.error("Failed to publish order {}", order))
                              .subscribe();
    }
}
