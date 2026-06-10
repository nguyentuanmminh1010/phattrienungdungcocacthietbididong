package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface OrderStatusRepository extends JpaRepository<OrderStatus, Long> {
}
