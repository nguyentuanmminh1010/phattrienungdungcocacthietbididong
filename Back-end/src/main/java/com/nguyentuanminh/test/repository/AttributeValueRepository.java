package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.AttributeValue;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface AttributeValueRepository extends JpaRepository<AttributeValue, UUID> {
    List<AttributeValue> findByAttributeId(UUID attributeId);
}
