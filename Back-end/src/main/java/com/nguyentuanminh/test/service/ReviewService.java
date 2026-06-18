package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.dto.ReviewDto;
import com.nguyentuanminh.test.entity.Product;
import com.nguyentuanminh.test.entity.Review;
import com.nguyentuanminh.test.entity.ReviewImage;
import com.nguyentuanminh.test.entity.User;
import com.nguyentuanminh.test.repository.ProductRepository;
import com.nguyentuanminh.test.repository.ReviewRepository;
import com.nguyentuanminh.test.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    private final String UPLOAD_DIR = "uploads/";

    public List<ReviewDto> getReviewsByProductId(UUID productId) {
        List<Review> reviews = reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);
        String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy");

        return reviews.stream().map(r -> {
            ReviewDto dto = new ReviewDto();
            dto.setId(r.getId());
            dto.setUserName(r.getUser().getName() != null ? r.getUser().getName() : "Anonymous");
            try {
                dto.setAvatar("https://ui-avatars.com/api/?name=" + java.net.URLEncoder.encode(dto.getUserName(), "UTF-8") + "&background=random");
            } catch (Exception e) {
                dto.setAvatar("https://ui-avatars.com/api/?name=User&background=random");
            }
            dto.setRating(r.getRating());
            dto.setComment(r.getComment());
            dto.setDate(r.getCreatedAt().format(formatter));
            
            List<String> imageUrls = r.getImages().stream()
                .map(img -> baseUrl + "/" + UPLOAD_DIR + img.getImageUrl())
                .collect(Collectors.toList());
            dto.setImages(imageUrls);
            return dto;
        }).collect(Collectors.toList());
    }

    public List<com.nguyentuanminh.test.dto.UserReviewDto> getUserReviews(Long userId) {
        List<Review> reviews = reviewRepository.findByUserIdOrderByCreatedAtDesc(userId);
        String baseUrl = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy");

        return reviews.stream().map(r -> {
            com.nguyentuanminh.test.dto.UserReviewDto dto = new com.nguyentuanminh.test.dto.UserReviewDto();
            dto.setId(r.getId());
            dto.setProductId(r.getProduct().getId());
            dto.setProductName(r.getProduct().getProductName());
            dto.setProductImageUrl(r.getProduct().getImageUrl() != null && !r.getProduct().getImageUrl().isEmpty() 
                ? (r.getProduct().getImageUrl().startsWith("http") ? r.getProduct().getImageUrl() : baseUrl + "/" + r.getProduct().getImageUrl()) 
                : "https://via.placeholder.com/150");
            dto.setRating(r.getRating());
            dto.setComment(r.getComment());
            dto.setDate(r.getCreatedAt().format(formatter));
            
            List<String> imageUrls = r.getImages().stream()
                .map(img -> baseUrl + "/" + UPLOAD_DIR + img.getImageUrl())
                .collect(Collectors.toList());
            dto.setImages(imageUrls);
            return dto;
        }).collect(Collectors.toList());
    }

    public void addReview(UUID productId, Long userId, Double rating, String comment, List<MultipartFile> files) throws IOException {
        Product product = productRepository.findById(productId).orElseThrow(() -> new RuntimeException("Product not found"));
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));

        Review review = Review.builder()
                .product(product)
                .user(user)
                .rating(rating)
                .comment(comment)
                .build();

        if (files != null && !files.isEmpty()) {
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
                    Path filePath = uploadPath.resolve(fileName);
                    Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    
                    ReviewImage reviewImage = ReviewImage.builder()
                            .imageUrl(fileName)
                            .review(review)
                            .build();
                    review.getImages().add(reviewImage);
                }
            }
        }

        reviewRepository.save(review);
        
        // Cập nhật lại rating tổng của Product
        List<Review> reviews = reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);
        double totalRating = 0;
        for (Review rv : reviews) {
            totalRating += rv.getRating();
        }
        double avgRating = reviews.size() > 0 ? totalRating / reviews.size() : 0.0;
        product.setRating(avgRating);
        product.setRatingCount(reviews.size());
        productRepository.save(product);
    }
}
