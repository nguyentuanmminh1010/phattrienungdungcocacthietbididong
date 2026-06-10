package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "roles") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Role {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "role_name", length = 255, nullable = false)
    private String roleName;
    @Column(columnDefinition = "TEXT")
    private String privileges;
}
