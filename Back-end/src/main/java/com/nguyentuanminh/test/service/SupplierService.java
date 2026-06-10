package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Supplier;
import com.nguyentuanminh.test.repository.SupplierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SupplierService {

    private final SupplierRepository repository;

    public List<Supplier> findAll() {
        return repository.findAll();
    }

    public Optional<Supplier> findById(Long id) {
        return repository.findById(id);
    }

    public Supplier save(Supplier entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
