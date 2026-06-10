package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.ShippingCountryZone;
import com.nguyentuanminh.test.repository.ShippingCountryZoneRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ShippingCountryZoneService {

    private final ShippingCountryZoneRepository repository;

    public List<ShippingCountryZone> findAll() {
        return repository.findAll();
    }

    public Optional<ShippingCountryZone> findById(Long id) {
        return repository.findById(id);
    }

    public ShippingCountryZone save(ShippingCountryZone entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
