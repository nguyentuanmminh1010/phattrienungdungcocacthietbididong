package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
}
