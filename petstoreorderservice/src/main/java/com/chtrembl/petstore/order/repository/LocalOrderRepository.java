package com.chtrembl.petstore.order.repository;

import com.azure.cosmos.models.CosmosPatchItemRequestOptions;
import com.azure.cosmos.models.CosmosPatchOperations;
import com.azure.cosmos.models.PartitionKey;
import com.chtrembl.petstore.order.model.Order;
import java.util.Optional;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Repository;

@Repository
@ConditionalOnProperty(name = "spring.cloud.azure.cosmos.enabled", havingValue = "false")
public class LocalOrderRepository implements OrderRepository {

	@Override
	public Optional<Order> findById(String s, PartitionKey partitionKey) {
		return Optional.empty();
	}

	@Override
	public void deleteById(String s, PartitionKey partitionKey) {

	}

	@Override
	public <S extends Order> S save(String s, PartitionKey partitionKey, Class<S> domainType,
			CosmosPatchOperations patchOperations) {
		return null;
	}

	@Override
	public <S extends Order> S save(String s, PartitionKey partitionKey, Class<S> domainType,
			CosmosPatchOperations patchOperations, CosmosPatchItemRequestOptions options) {
		return null;
	}

	@Override
	public Iterable<Order> findAll(PartitionKey partitionKey) {
		return null;
	}

	@Override
	public Iterable<Order> findAll(Sort sort) {
		return null;
	}

	@Override
	public Page<Order> findAll(Pageable pageable) {
		return null;
	}

	@Override
	public <S extends Order> S save(S entity) {
		return null;
	}

	@Override
	public <S extends Order> Iterable<S> saveAll(Iterable<S> entities) {
		return null;
	}

	@Override
	public Optional<Order> findById(String s) {
		return Optional.empty();
	}

	@Override
	public boolean existsById(String s) {
		return false;
	}

	@Override
	public Iterable<Order> findAll() {
		return null;
	}

	@Override
	public Iterable<Order> findAllById(Iterable<String> strings) {
		return null;
	}

	@Override
	public long count() {
		return 0;
	}

	@Override
	public void deleteById(String s) {

	}

	@Override
	public void delete(Order entity) {

	}

	@Override
	public void deleteAllById(Iterable<? extends String> strings) {

	}

	@Override
	public void deleteAll(Iterable<? extends Order> entities) {

	}

	@Override
	public void deleteAll() {

	}
}
