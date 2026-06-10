package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Attribute;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.UUID;

public interface AttributeRepository extends JpaRepository<Attribute, UUID> {
    Optional<Attribute> findByAttributeName(String attributeName);
}
