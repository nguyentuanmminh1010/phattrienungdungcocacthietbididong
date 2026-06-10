package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductAttribute;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface ProductAttributeRepository extends JpaRepository<ProductAttribute, Long> {
}
