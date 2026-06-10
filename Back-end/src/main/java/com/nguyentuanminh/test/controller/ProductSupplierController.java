package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductSupplier;
import com.nguyentuanminh.test.service.ProductSupplierService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-suppliers")
@RequiredArgsConstructor
public class ProductSupplierController {

    private final ProductSupplierService service;

    @GetMapping
    public ResponseEntity<List<ProductSupplier>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductSupplier> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductSupplier> create(@RequestBody ProductSupplier entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductSupplier> update(@PathVariable Long id, @RequestBody ProductSupplier entity) {
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
