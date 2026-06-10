package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Gallery;
import com.nguyentuanminh.test.repository.GalleryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class GalleryService {

    private final GalleryRepository repository;

    public List<Gallery> findAll() {
        return repository.findAll();
    }

    public Optional<Gallery> findById(Long id) {
        return repository.findById(id);
    }

    public Gallery save(Gallery entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
