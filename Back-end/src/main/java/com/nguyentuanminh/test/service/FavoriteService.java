package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.dto.FavoriteRequest;
import com.nguyentuanminh.test.dto.FavoriteResponse;
import com.nguyentuanminh.test.entity.Favorite;
import com.nguyentuanminh.test.entity.Product;
import com.nguyentuanminh.test.entity.User;
import com.nguyentuanminh.test.repository.FavoriteRepository;
import com.nguyentuanminh.test.repository.ProductRepository;
import com.nguyentuanminh.test.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public FavoriteResponse addFavorite(FavoriteRequest request, String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Optional<Favorite> existing = favoriteRepository.findByUserEmailAndProductIdAndSize(
                email, request.getProductId(), request.getSize());
        
        if (existing.isPresent()) {
            throw new RuntimeException("Product already in favorites with this size");
        }

        Favorite favorite = Favorite.builder()
                .user(user)
                .product(product)
                .size(request.getSize())
                .createdAt(LocalDateTime.now())
                .build();

        favorite = favoriteRepository.save(favorite);
        return mapToResponse(favorite);
    }

    public List<FavoriteResponse> getFavoritesByEmail(String email) {
        return favoriteRepository.findByUserEmailOrderByCreatedAtDesc(email)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public void removeFavorite(Long favoriteId) {
        if (favoriteRepository.existsById(favoriteId)) {
            favoriteRepository.deleteById(favoriteId);
        } else {
            throw new RuntimeException("Favorite not found");
        }
    }

    private FavoriteResponse mapToResponse(Favorite favorite) {
        return FavoriteResponse.builder()
                .id(favorite.getId())
                .userId(favorite.getUser().getId())
                .productId(favorite.getProduct().getId())
                .productName(favorite.getProduct().getProductName())
                .imageUrl(favorite.getProduct().getImageUrl())
                .salePrice(favorite.getProduct().getSalePrice())
                .brand(favorite.getProduct().getBrand())
                .size(favorite.getSize())
                .build();
    }
}
