package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.CustomerAddress;
import com.nguyentuanminh.test.repository.CustomerAddressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerAddressService {

    private final CustomerAddressRepository repository;

    public List<CustomerAddress> findAll() {
        return repository.findAll();
    }

    public Optional<CustomerAddress> findById(Long id) {
        return repository.findById(id);
    }

    public CustomerAddress save(CustomerAddress entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
