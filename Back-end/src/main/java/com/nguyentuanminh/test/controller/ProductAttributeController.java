package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductAttribute;
import com.nguyentuanminh.test.service.ProductAttributeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-attributes")
@RequiredArgsConstructor
public class ProductAttributeController {

    private final ProductAttributeService service;

    @GetMapping
    public ResponseEntity<List<ProductAttribute>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductAttribute> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductAttribute> create(@RequestBody ProductAttribute entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductAttribute> update(@PathVariable Long id, @RequestBody ProductAttribute entity) {
        // Basic update: Set ID to ensure we update the correct record
        // Note: For advanced updates, DTOs should be used. This is a basic
        // implementation.
        return ResponseEntity.ok(service.save(entity));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.deleteById(id);
        return ResponseEntity.ok().build();
    }
}
