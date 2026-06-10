package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Sell;
import com.nguyentuanminh.test.repository.SellRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SellService {

    private final SellRepository repository;

    public List<Sell> findAll() {
        return repository.findAll();
    }

    public Optional<Sell> findById(Long id) {
        return repository.findById(id);
    }

    public Sell save(Sell entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
