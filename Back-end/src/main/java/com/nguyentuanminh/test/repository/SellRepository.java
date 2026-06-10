package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Sell;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface SellRepository extends JpaRepository<Sell, Long> {
}
