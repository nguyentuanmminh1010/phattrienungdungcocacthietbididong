package com.nguyentuanminh.test.dto;

import com.nguyentuanminh.test.entity.Product;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class ProductDetailDto {
    private Product product;
    private List<String> sizes;
    private List<String> colors;
    private List<String> imageGallery;
}
