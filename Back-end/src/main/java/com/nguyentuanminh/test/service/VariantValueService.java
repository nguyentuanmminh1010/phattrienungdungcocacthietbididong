package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.VariantValue;
import com.nguyentuanminh.test.repository.VariantValueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VariantValueService {

    private final VariantValueRepository repository;

    public List<VariantValue> findAll() {
        return repository.findAll();
    }

    public Optional<VariantValue> findById(Long id) {
        return repository.findById(id);
    }

    public VariantValue save(VariantValue entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
