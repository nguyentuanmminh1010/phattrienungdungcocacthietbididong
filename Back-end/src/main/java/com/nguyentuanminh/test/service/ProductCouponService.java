package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ProductCoupon;
import com.nguyentuanminh.test.repository.ProductCouponRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductCouponService {

    private final ProductCouponRepository repository;

    public List<ProductCoupon> findAll() {
        return repository.findAll();
    }

    public Optional<ProductCoupon> findById(Long id) {
        return repository.findById(id);
    }

    public ProductCoupon save(ProductCoupon entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
