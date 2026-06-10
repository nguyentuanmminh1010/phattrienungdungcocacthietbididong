package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "shipping_country_zones")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShippingCountryZone {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
