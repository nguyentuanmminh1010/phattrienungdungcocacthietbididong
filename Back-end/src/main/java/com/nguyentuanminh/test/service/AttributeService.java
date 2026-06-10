package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Attribute;
import com.nguyentuanminh.test.repository.AttributeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AttributeService {

    private final AttributeRepository repository;

    public List<Attribute> findAll() {
        return repository.findAll();
    }

    public Optional<Attribute> findById(UUID id) {
        return repository.findById(id);
    }

    public Attribute save(Attribute entity) {
        return repository.save(entity);
    }

    public void deleteById(UUID id) {
        repository.deleteById(id);
    }
}
