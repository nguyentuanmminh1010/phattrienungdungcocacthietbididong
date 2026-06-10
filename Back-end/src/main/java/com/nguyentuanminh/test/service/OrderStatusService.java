package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.OrderStatus;
import com.nguyentuanminh.test.repository.OrderStatusRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderStatusService {

    private final OrderStatusRepository repository;

    public List<OrderStatus> findAll() {
        return repository.findAll();
    }

    public Optional<OrderStatus> findById(Long id) {
        return repository.findById(id);
    }

    public OrderStatus save(OrderStatus entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
