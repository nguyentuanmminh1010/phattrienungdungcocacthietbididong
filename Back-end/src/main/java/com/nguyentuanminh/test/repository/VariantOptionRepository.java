package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.VariantOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface VariantOptionRepository extends JpaRepository<VariantOption, Long> {
}
