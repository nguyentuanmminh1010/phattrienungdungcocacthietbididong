package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.dto.FavoriteRequest;
import com.nguyentuanminh.test.dto.FavoriteResponse;
import com.nguyentuanminh.test.entity.Favorite;
import com.nguyentuanminh.test.entity.Product;
import com.nguyentuanminh.test.entity.User;
import com.nguyentuanminh.test.repository.FavoriteRepository;
import com.nguyentuanminh.test.repository.ProductRepository;
import com.nguyentuanminh.test.repository.UserRepository;
import com.nguyentuanminh.test.repository.ProductAttributeValueRepository;
import com.nguyentuanminh.test.entity.ProductAttributeValue;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final ProductAttributeValueRepository productAttributeValueRepository;

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
        List<Favorite> favorites = favoriteRepository.findByUserEmailOrderByCreatedAtDesc(email);
        if (favorites.isEmpty()) return new ArrayList<>();

        List<UUID> productIds = favorites.stream().map(f -> f.getProduct().getId()).toList();
        List<ProductAttributeValue> pavs = productAttributeValueRepository.findByProductIdIn(productIds);
        Map<UUID, List<ProductAttributeValue>> pavMap = new HashMap<>();
        for (ProductAttributeValue pav : pavs) {
            pavMap.computeIfAbsent(pav.getProduct().getId(), k -> new ArrayList<>()).add(pav);
        }

        return favorites.stream().map(f -> {
            FavoriteResponse resp = mapToResponse(f);
            List<ProductAttributeValue> pPavs = pavMap.getOrDefault(f.getProduct().getId(), new ArrayList<>());
            List<String> sizes = new ArrayList<>();
            List<String> colors = new ArrayList<>();
            for (ProductAttributeValue pav : pPavs) {
                String attrName = pav.getAttributeValue().getAttribute().getAttributeName();
                String attrVal = pav.getAttributeValue().getValue();
                if ("Size".equalsIgnoreCase(attrName)) {
                    sizes.add(attrVal);
                } else if ("Color".equalsIgnoreCase(attrName)) {
                    colors.add(attrVal);
                }
            }
            resp.setAvailableSizes(sizes);
            resp.setAvailableColors(colors);
            return resp;
        }).collect(Collectors.toList());
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
                .rating(favorite.getProduct().getRating())
                .ratingCount(favorite.getProduct().getRatingCount())
                .isNewBadge(favorite.getProduct().getIsNewBadge())
                .size(favorite.getSize())
                .build();
    }
}
