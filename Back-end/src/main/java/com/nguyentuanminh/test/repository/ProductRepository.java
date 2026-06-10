package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {
    
    @Query("SELECT p FROM Product p JOIN p.productTags pt JOIN pt.tag t WHERE t.tagName = :tagName")
    List<Product> findByTagName(@Param("tagName") String tagName);

    @Query("SELECT p FROM Product p JOIN p.productCategories pc JOIN pc.category c WHERE c.id = :categoryId")
    List<Product> findByCategoriesId(@Param("categoryId") Long categoryId);
}
