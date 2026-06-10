package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ShippingZone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ShippingZoneRepository extends JpaRepository<ShippingZone, Long> {
}
