package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Variant;
import com.nguyentuanminh.test.repository.VariantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VariantService {

    private final VariantRepository repository;

    public List<Variant> findAll() {
        return repository.findAll();
    }

    public Optional<Variant> findById(Long id) {
        return repository.findById(id);
    }

    public Variant save(Variant entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
