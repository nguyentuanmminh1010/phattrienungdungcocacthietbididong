package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "variant_values")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VariantValue {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}
