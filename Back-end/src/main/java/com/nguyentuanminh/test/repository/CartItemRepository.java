package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    Optional<CartItem> findByCartIdAndProductIdAndSizeAndColor(Long cartId, UUID productId, String size, String color);
    List<CartItem> findByCartId(Long cartId);
}
