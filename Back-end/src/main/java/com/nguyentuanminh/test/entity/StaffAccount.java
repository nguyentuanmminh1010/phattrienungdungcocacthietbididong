package com.nguyentuanminh.test.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;

@Entity
@Table(name = "staff_accounts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StaffAccount {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "first_name", length = 100, nullable = false)
    private String firstName;

    @Column(name = "last_name", length = 100, nullable = false)
    private String lastName;

    @Column(name = "phone_number", length = 100)
    private String phoneNumber;

    @Column(length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash")
    private String passwordHash;

    private Boolean active;
    private String image;
    private String placeholder;

    // Gộp bảng roles
    @Column(name = "role_name", length = 255)
    private String roleName;

    @Column(columnDefinition = "TEXT")
    private String privileges;
}
