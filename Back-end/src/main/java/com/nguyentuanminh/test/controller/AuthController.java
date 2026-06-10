package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.dto.request.LoginRequest;
import com.nguyentuanminh.test.dto.request.RegisterRequest;
import com.nguyentuanminh.test.dto.request.SocialLoginRequest;
import com.nguyentuanminh.test.dto.response.AuthResponse;
import com.nguyentuanminh.test.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/google")
    public ResponseEntity<AuthResponse> googleLogin(@RequestBody SocialLoginRequest request) {
        return ResponseEntity.ok(authService.googleLogin(request));
    }

    @PostMapping("/facebook")
    public ResponseEntity<AuthResponse> facebookLogin(@RequestBody SocialLoginRequest request) {
        return ResponseEntity.ok(authService.facebookLogin(request));
    }
}