package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ProductSupplier;
import com.nguyentuanminh.test.repository.ProductSupplierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductSupplierService {

    private final ProductSupplierRepository repository;

    public List<ProductSupplier> findAll() {
        return repository.findAll();
    }

    public Optional<ProductSupplier> findById(Long id) {
        return repository.findById(id);
    }

    public ProductSupplier save(ProductSupplier entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
