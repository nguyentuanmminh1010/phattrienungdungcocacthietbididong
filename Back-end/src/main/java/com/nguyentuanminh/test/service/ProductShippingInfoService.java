package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ProductShippingInfo;
import com.nguyentuanminh.test.repository.ProductShippingInfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductShippingInfoService {

    private final ProductShippingInfoRepository repository;

    public List<ProductShippingInfo> findAll() {
        return repository.findAll();
    }

    public Optional<ProductShippingInfo> findById(Long id) {
        return repository.findById(id);
    }

    public ProductShippingInfo save(ProductShippingInfo entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
