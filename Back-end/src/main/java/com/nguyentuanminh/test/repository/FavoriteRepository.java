package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    List<Favorite> findByUserEmailOrderByCreatedAtDesc(String email);
    
    Optional<Favorite> findByUserEmailAndProductIdAndSize(String email, java.util.UUID productId, String size);
}
