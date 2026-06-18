package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.ProductAttributeValue;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface ProductAttributeValueRepository extends JpaRepository<ProductAttributeValue, UUID> {
    List<ProductAttributeValue> findByProductId(UUID productId);
    List<ProductAttributeValue> findByProductIdIn(List<UUID> productIds);
}
