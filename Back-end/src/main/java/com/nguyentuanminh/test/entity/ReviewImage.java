package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "product_review_images")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReviewImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "review_id", nullable = false)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @com.fasterxml.jackson.annotation.JsonIgnore
    private Review review;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;
}
