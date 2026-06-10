package com.nguyentuanminh.test.dto.request;

import lombok.Data;

@Data
public class SocialLoginRequest {
    private String token; // Token gửi từ client (app mobile)
    private String action; // "LOGIN" hoặc "REGISTER"
}