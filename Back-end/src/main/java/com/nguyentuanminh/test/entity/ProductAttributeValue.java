package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;

@Entity
@Table(name = "product_attribute_values")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductAttributeValue {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private Product product;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "attribute_value_id", nullable = false)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private AttributeValue attributeValue;
}
