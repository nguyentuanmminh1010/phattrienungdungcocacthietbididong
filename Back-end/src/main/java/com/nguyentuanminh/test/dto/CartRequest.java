package com.nguyentuanminh.test.dto;

import lombok.Data;
import java.util.UUID;

@Data
public class CartRequest {
    private UUID productId;
    private Integer quantity;
    private String size;
    private String color;
}
