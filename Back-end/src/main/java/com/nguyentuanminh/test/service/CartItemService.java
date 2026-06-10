package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.entity.CartItem;
import com.nguyentuanminh.test.repository.CartItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartItemService {

    private final CartItemRepository repository;

    public List<CartItem> findAll() {
        return repository.findAll();
    }

    public Optional<CartItem> findById(Long id) {
        return repository.findById(id);
    }

    public CartItem save(CartItem entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
