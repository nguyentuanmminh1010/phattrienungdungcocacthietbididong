package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.Cart;
import com.nguyentuanminh.test.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository repository;

    public List<Cart> findAll() {
        return repository.findAll();
    }

    public Optional<Cart> findById(Long id) {
        return repository.findById(id);
    }

    public Cart save(Cart entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
