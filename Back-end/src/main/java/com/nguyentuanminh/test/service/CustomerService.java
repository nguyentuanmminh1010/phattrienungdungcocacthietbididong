package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Customer;
import com.nguyentuanminh.test.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository repository;

    public List<Customer> findAll() {
        return repository.findAll();
    }

    public Optional<Customer> findById(UUID id) {
        return repository.findById(id);
    }

    public Customer save(Customer entity) {
        return repository.save(entity);
    }

    public void deleteById(UUID id) {
        repository.deleteById(id);
    }
}
