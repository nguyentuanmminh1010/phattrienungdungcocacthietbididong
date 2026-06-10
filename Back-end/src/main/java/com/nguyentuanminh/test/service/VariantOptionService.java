package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.VariantOption;
import com.nguyentuanminh.test.repository.VariantOptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VariantOptionService {

    private final VariantOptionRepository repository;

    public List<VariantOption> findAll() {
        return repository.findAll();
    }

    public Optional<VariantOption> findById(Long id) {
        return repository.findById(id);
    }

    public VariantOption save(VariantOption entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
