package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ShippingZone;
import com.nguyentuanminh.test.repository.ShippingZoneRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ShippingZoneService {

    private final ShippingZoneRepository repository;

    public List<ShippingZone> findAll() {
        return repository.findAll();
    }

    public Optional<ShippingZone> findById(Long id) {
        return repository.findById(id);
    }

    public ShippingZone save(ShippingZone entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
