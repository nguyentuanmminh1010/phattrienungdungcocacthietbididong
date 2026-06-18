package com.nguyentuanminh.test.dto;

import lombok.Data;
import java.util.List;
import java.util.UUID;

@Data
public class UserReviewDto {
    private Long id;
    private UUID productId;
    private String productName;
    private String productImageUrl;
    private Double rating;
    private String date;
    private String comment;
    private List<String> images;
}
