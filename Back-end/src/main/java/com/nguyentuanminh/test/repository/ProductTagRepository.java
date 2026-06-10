package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductTagRepository extends JpaRepository<ProductTag, Long> {
}
