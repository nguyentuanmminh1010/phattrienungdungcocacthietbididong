package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "products")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "product_name", length = 255)
    private String productName;

    @Column(name = "sale_price")
    private Double salePrice;

    @Column(name = "compare_price")
    private Double comparePrice;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "image_url_2")
    private String imageUrl2;

    @Column(name = "image_url_3")
    private String imageUrl3;

    private String brand;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private Double rating;

    @Column(name = "rating_count")
    private Integer ratingCount;

    @Column(name = "is_new_badge")
    private Boolean isNewBadge;

    @Column(name = "discount_tag")
    private String discountTag;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @Builder.Default
    private Set<ProductTag> productTags = new HashSet<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @Builder.Default
    private Set<ProductCategory> productCategories = new HashSet<>();
}
