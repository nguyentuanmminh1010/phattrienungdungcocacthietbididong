package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "product_coupons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductCoupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
