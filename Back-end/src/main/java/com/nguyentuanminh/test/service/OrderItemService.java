package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.OrderItem;
import com.nguyentuanminh.test.repository.OrderItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderItemService {

    private final OrderItemRepository repository;

    public List<OrderItem> findAll() {
        return repository.findAll();
    }

    public Optional<OrderItem> findById(Long id) {
        return repository.findById(id);
    }

    public OrderItem save(OrderItem entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
