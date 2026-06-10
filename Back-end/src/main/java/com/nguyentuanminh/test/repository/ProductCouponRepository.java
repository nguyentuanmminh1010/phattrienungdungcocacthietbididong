package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductCoupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ProductCouponRepository extends JpaRepository<ProductCoupon, Long> {
}
