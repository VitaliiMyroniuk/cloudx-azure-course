package com.chtrembl.petstore.product.service;

import com.chtrembl.petstore.product.model.Product;
import static com.chtrembl.petstore.product.model.Product.StatusEnum;
import com.chtrembl.petstore.product.repository.ProductRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {

	private final ProductRepository petRepository;

	public List<Product> getProducts(List<String> statuses) {
		List<StatusEnum> statusEnums = statuses
				.stream()
				.map(StatusEnum::fromValue)
				.toList();
		return petRepository.findAllByStatusIn(statusEnums);
	}
}
