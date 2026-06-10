package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductShippingInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ProductShippingInfoRepository extends JpaRepository<ProductShippingInfo, Long> {
}
