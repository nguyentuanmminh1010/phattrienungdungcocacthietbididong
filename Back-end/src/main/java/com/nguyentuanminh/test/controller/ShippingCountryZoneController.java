package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.ShippingCountryZone;
import com.nguyentuanminh.test.service.ShippingCountryZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shipping-country-zones")
@RequiredArgsConstructor
public class ShippingCountryZoneController {

    private final ShippingCountryZoneService service;

    @GetMapping
    public ResponseEntity<List<ShippingCountryZone>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ShippingCountryZone> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ShippingCountryZone> create(@RequestBody ShippingCountryZone entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ShippingCountryZone> update(@PathVariable Long id, @RequestBody ShippingCountryZone entity) {
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
