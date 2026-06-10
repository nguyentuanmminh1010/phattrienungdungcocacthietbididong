package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Variant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface VariantRepository extends JpaRepository<Variant, Long> {
}
