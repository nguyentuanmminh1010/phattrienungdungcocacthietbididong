package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductSupplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ProductSupplierRepository extends JpaRepository<ProductSupplier, Long> {
}
