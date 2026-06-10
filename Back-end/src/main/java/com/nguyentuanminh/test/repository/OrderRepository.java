package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
}
