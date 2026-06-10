package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.dto.ReviewDto;
import com.nguyentuanminh.test.service.ReviewService;
import com.nguyentuanminh.test.repository.UserRepository;
import com.nguyentuanminh.test.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/{productId}")
    public ResponseEntity<List<ReviewDto>> getReviews(@PathVariable UUID productId) {
        return ResponseEntity.ok(reviewService.getReviewsByProductId(productId));
    }

    @PostMapping("/{productId}")
    public ResponseEntity<?> addReview(
            @PathVariable UUID productId,
            @RequestParam("rating") Double rating,
            @RequestParam("comment") String comment,
            @RequestParam(value = "images", required = false) List<MultipartFile> images) {

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String email = authentication.getName();

            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            reviewService.addReview(productId, user.getId(), rating, comment, images);
            return ResponseEntity.ok("Review added successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}
