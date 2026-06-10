package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;

@Entity
@Table(name = "attribute_values")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AttributeValue {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "value", nullable = false, length = 100)
    private String value;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "attribute_id", nullable = false)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private Attribute attribute;
}
