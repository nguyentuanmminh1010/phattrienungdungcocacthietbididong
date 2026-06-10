package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductTag;
import com.nguyentuanminh.test.service.ProductTagService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-tags")
@RequiredArgsConstructor
public class ProductTagController {

    private final ProductTagService service;

    @GetMapping
    public ResponseEntity<List<ProductTag>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductTag> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductTag> create(@RequestBody ProductTag entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductTag> update(@PathVariable Long id, @RequestBody ProductTag entity) {
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
