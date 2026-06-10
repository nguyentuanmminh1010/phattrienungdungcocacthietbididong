package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ShippingRate;
import com.nguyentuanminh.test.repository.ShippingRateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ShippingRateService {

    private final ShippingRateRepository repository;

    public List<ShippingRate> findAll() {
        return repository.findAll();
    }

    public Optional<ShippingRate> findById(Long id) {
        return repository.findById(id);
    }

    public ShippingRate save(ShippingRate entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
