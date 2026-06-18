package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.dto.CartRequest;
import com.nguyentuanminh.test.dto.CartResponse;
import com.nguyentuanminh.test.entity.Coupon;
import com.nguyentuanminh.test.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping
    public ResponseEntity<CartResponse> getCart(Authentication authentication) {
        String email = authentication.getName();
        return ResponseEntity.ok(cartService.getCart(email));
    }

    @PostMapping("/add")
    public ResponseEntity<CartResponse> addToCart(Authentication authentication, @RequestBody CartRequest request) {
        String email = authentication.getName();
        return ResponseEntity.ok(cartService.addToCart(email, request));
    }

    @PutMapping("/items/{itemId}")
    public ResponseEntity<CartResponse> updateQuantity(
            Authentication authentication,
            @PathVariable Long itemId,
            @RequestParam int delta) {
        String email = authentication.getName();
        return ResponseEntity.ok(cartService.updateQuantity(email, itemId, delta));
    }

    @PostMapping("/apply-coupon")
    public ResponseEntity<CartResponse> applyCoupon(
            Authentication authentication,
            @RequestParam(required = false) String code) {
        String email = authentication.getName();
        return ResponseEntity.ok(cartService.applyCoupon(email, code));
    }

    @GetMapping("/coupons")
    public ResponseEntity<List<Coupon>> getAvailableCoupons() {
        return ResponseEntity.ok(cartService.getAvailableCoupons());
    }
}
