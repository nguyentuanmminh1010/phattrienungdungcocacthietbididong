package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Country;
import com.nguyentuanminh.test.repository.CountryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CountryService {

    private final CountryRepository repository;

    public List<Country> findAll() {
        return repository.findAll();
    }

    public Optional<Country> findById(Long id) {
        return repository.findById(id);
    }

    public Country save(Country entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
