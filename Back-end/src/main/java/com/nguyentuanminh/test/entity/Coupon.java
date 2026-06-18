package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "coupons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String code;

    @Column(name = "discount_percentage")
    private Integer discountPercentage;

    private String title;

    @Column(name = "days_remaining")
    private Integer daysRemaining;
}
