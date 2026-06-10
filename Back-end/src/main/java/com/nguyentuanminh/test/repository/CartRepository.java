package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
}
