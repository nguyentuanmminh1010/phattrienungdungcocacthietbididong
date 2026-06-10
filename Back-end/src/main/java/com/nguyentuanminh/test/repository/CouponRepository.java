package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CouponRepository extends JpaRepository<Coupon, Long> {
}
