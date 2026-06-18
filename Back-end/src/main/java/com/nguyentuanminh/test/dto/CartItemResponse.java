package com.nguyentuanminh.test.dto;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data
@Builder
public class CartItemResponse {
    private Long id;
    private UUID productId;
    private String productName;
    private String imageUrl;
    private Double price;
    private String brand;
    private String size;
    private String color;
    private Integer quantity;
}
