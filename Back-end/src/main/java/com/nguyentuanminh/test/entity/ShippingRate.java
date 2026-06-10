package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "shipping_rates")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShippingRate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
