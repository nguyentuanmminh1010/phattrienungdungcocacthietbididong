package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ShippingCountryZone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ShippingCountryZoneRepository extends JpaRepository<ShippingCountryZone, Long> {
}
