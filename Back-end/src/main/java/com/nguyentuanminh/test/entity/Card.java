package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = "cards") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Card {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = "customer_id") private UUID customerId;
}
