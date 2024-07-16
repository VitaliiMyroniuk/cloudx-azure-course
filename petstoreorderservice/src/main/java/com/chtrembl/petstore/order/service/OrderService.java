package com.chtrembl.petstore.order.service;

import com.chtrembl.petstore.order.model.Order;
import com.chtrembl.petstore.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderService {

	private static final Logger log = LoggerFactory.getLogger(OrderService.class);

	private final OrderRepository orderRepository;

	public void save(Order order) {
		log.info("Going to save order {}", order);
		orderRepository.save(order);
	}
}
