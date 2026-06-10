package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.StaffAccount;
import com.nguyentuanminh.test.repository.StaffAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class StaffAccountService {

    private final StaffAccountRepository repository;

    public List<StaffAccount> findAll() {
        return repository.findAll();
    }

    public Optional<StaffAccount> findById(UUID id) {
        return repository.findById(id);
    }

    public StaffAccount save(StaffAccount entity) {
        return repository.save(entity);
    }

    public void deleteById(UUID id) {
        repository.deleteById(id);
    }
}
