package com.nguyentuanminh.test.dto;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;

@Data
@Builder
public class FavoriteResponse {
    private Long id;
    private Long userId;
    private UUID productId;
    private String productName;
    private String imageUrl;
    private Double salePrice;
    private String brand;
    private String size;
}
