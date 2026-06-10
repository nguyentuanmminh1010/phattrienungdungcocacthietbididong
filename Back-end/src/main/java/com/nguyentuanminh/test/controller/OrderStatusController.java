package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.OrderStatus;
import com.nguyentuanminh.test.service.OrderStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/order-statuss")
@RequiredArgsConstructor
public class OrderStatusController {

    private final OrderStatusService service;

    @GetMapping
    public ResponseEntity<List<OrderStatus>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderStatus> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<OrderStatus> create(@RequestBody OrderStatus entity) {
        return ResponseEntity.ok(service.save(entity));
    }

    @PutMapping("/{id}")
    public ResponseEntity<OrderStatus> update(@PathVariable Long id, @RequestBody OrderStatus entity) {
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
