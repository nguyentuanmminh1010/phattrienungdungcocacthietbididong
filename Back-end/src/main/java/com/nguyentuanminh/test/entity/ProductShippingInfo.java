package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "product_shipping_info")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductShippingInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
