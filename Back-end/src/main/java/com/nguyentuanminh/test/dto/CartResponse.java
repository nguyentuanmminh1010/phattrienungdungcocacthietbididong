package com.nguyentuanminh.test.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class CartResponse {
    private Long cartId;
    private List<CartItemResponse> items;
    private Double totalAmount;
    private Double totalAmountAfterDiscount;
    private String appliedCouponCode;
    private Integer discountPercentage;
}
