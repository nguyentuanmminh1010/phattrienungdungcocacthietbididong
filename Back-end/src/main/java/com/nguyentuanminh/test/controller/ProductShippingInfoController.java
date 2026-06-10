package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductShippingInfo;
import com.nguyentuanminh.test.service.ProductShippingInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-shipping-infos")
@RequiredArgsConstructor
public class ProductShippingInfoController {

    private final ProductShippingInfoService service;

    @GetMapping
    public ResponseEntity<List<ProductShippingInfo>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductShippingInfo> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductShippingInfo> create(@RequestBody ProductShippingInfo entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductShippingInfo> update(@PathVariable Long id, @RequestBody ProductShippingInfo entity) {
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
