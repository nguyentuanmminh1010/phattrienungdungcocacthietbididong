package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ShippingRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ShippingRateRepository extends JpaRepository<ShippingRate, Long> {
}
