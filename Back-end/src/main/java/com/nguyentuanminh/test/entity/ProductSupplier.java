package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "product_suppliers")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductSupplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
