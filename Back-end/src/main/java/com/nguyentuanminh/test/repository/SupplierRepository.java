package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface SupplierRepository extends JpaRepository<Supplier, Long> {
}
