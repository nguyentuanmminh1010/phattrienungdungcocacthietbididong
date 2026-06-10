package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ProductAttribute;
import com.nguyentuanminh.test.repository.ProductAttributeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductAttributeService {

    private final ProductAttributeRepository repository;

    public List<ProductAttribute> findAll() {
        return repository.findAll();
    }

    public Optional<ProductAttribute> findById(Long id) {
        return repository.findById(id);
    }

    public ProductAttribute save(ProductAttribute entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
