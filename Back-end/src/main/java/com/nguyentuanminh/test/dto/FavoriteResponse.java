package com.nguyentuanminh.test.dto;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;
import java.util.List;

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
    private Double rating;
    private Integer ratingCount;
    private Boolean isNewBadge;
    private String size;
    private List<String> availableSizes;
    private List<String> availableColors;
}
