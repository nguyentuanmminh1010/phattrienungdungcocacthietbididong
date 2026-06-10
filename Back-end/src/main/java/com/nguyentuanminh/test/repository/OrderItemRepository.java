package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
}
