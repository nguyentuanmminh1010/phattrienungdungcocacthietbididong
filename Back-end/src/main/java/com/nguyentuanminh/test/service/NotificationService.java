package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Notification;
import com.nguyentuanminh.test.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository repository;

    public List<Notification> findAll() {
        return repository.findAll();
    }

    public Optional<Notification> findById(Long id) {
        return repository.findById(id);
    }

    public Notification save(Notification entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
