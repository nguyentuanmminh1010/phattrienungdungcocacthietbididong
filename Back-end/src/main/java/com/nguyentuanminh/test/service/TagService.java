package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Tag;
import com.nguyentuanminh.test.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TagService {

    private final TagRepository repository;

    public List<Tag> findAll() {
        return repository.findAll();
    }

    public Optional<Tag> findById(UUID id) {
        return repository.findById(id);
    }

    public Tag save(Tag entity) {
        return repository.save(entity);
    }

    public void deleteById(UUID id) {
        repository.deleteById(id);
    }
}
