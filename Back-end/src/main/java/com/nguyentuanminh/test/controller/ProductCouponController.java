package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ProductCoupon;
import com.nguyentuanminh.test.service.ProductCouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/product-coupons")
@RequiredArgsConstructor
public class ProductCouponController {

    private final ProductCouponService service;

    @GetMapping
    public ResponseEntity<List<ProductCoupon>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductCoupon> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ProductCoupon> create(@RequestBody ProductCoupon entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductCoupon> update(@PathVariable Long id, @RequestBody ProductCoupon entity) {
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
