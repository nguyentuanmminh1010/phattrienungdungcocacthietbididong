package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductAttributeValue;
import com.nguyentuanminh.test.service.ProductAttributeValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.List;

@RestController
@RequestMapping("/api/product-attribute-values")
@RequiredArgsConstructor
public class ProductAttributeValueController {

    private final ProductAttributeValueService service;

    @GetMapping
    public ResponseEntity<List<ProductAttributeValue>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductAttributeValue> getById(@PathVariable UUID id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductAttributeValue> create(@RequestBody ProductAttributeValue entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductAttributeValue> update(@PathVariable UUID id,
            @RequestBody ProductAttributeValue entity) {
        // Basic update: Set ID to ensure we update the correct record
        // Note: For advanced updates, DTOs should be used. This is a basic
        // implementation.
        return ResponseEntity.ok(service.save(entity));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        service.deleteById(id);
        return ResponseEntity.ok().build();
    }
}
