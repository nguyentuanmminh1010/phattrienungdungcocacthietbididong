package com.nguyentuanminh.test.dto;

import lombok.Data;
import java.util.UUID;

@Data
public class FavoriteRequest {
    private UUID productId;
    private String size;
}
