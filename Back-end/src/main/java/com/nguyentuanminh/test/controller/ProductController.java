package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.entity.Product;
import com.nguyentuanminh.test.entity.Tag;
import com.nguyentuanminh.test.entity.ProductTag;
import com.nguyentuanminh.test.repository.ProductRepository;
import com.nguyentuanminh.test.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import com.nguyentuanminh.test.dto.ProductDetailDto;
import com.nguyentuanminh.test.entity.ProductAttributeValue;
import com.nguyentuanminh.test.repository.ProductAttributeValueRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductRepository productRepository;
    private final TagRepository tagRepository;
    private final ProductAttributeValueRepository productAttributeValueRepository;

    @GetMapping
    public ResponseEntity<List<Product>> getProducts(
            @RequestParam(required = false) String tag,
            @RequestParam(required = false) Long categoryId) {
        if (categoryId != null) {
            return ResponseEntity.ok(productRepository.findByCategoriesId(categoryId));
        }
        if (tag != null && !tag.isEmpty()) {
            return ResponseEntity.ok(productRepository.findByTagName(tag));
        }
        return ResponseEntity.ok(productRepository.findAll());
    }

    @GetMapping("/debug/categories")
    public ResponseEntity<List<String>> debugCategories() {
        return ResponseEntity.ok(productRepository.findAll().stream()
                .map(p -> p.getProductName() + ": "
                        + p.getProductCategories().stream()
                                .map(c -> c.getCategory().getId() + "-" + c.getCategory().getCategoryName()).toList())
                .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductDetailDto> getProductDetail(@PathVariable UUID id) {
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        Product product = productOpt.get();

        List<ProductAttributeValue> pavs = productAttributeValueRepository.findByProductId(id);
        List<String> sizes = new ArrayList<>();
        List<String> colors = new ArrayList<>();

        for (ProductAttributeValue pav : pavs) {
            String attrName = pav.getAttributeValue().getAttribute().getAttributeName();
            String attrValue = pav.getAttributeValue().getValue();
            if ("Size".equalsIgnoreCase(attrName)) {
                sizes.add(attrValue);
            } else if ("Color".equalsIgnoreCase(attrName)) {
                colors.add(attrValue);
            }
        }

        List<String> imageGallery = new ArrayList<>();
        if (product.getImageUrl() != null)
            imageGallery.add(product.getImageUrl());
        if (product.getImageUrl2() != null)
            imageGallery.add(product.getImageUrl2());
        if (product.getImageUrl3() != null)
            imageGallery.add(product.getImageUrl3());

        return ResponseEntity.ok(ProductDetailDto.builder()
                .product(product)
                .sizes(sizes)
                .colors(colors)
                .imageGallery(imageGallery)
                .build());
    }

    @GetMapping("/{id}/related")
    public ResponseEntity<List<Product>> getRelatedProducts(@PathVariable UUID id) {
        List<Product> all = productRepository.findAll();
        List<Product> related = new ArrayList<>();
        for (Product p : all) {
            if (!p.getId().equals(id)) {
                related.add(p);
                if (related.size() >= 4)
                    break;
            }
        }
        return ResponseEntity.ok(related);
    }

    // API phục vụ cho việc đổi tag sản phẩm qua Postman để test
    @PutMapping("/{id}/tags")
    public ResponseEntity<Product> updateProductTags(@PathVariable UUID id, @RequestBody List<String> tags) {
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isEmpty()) {
            throw new RuntimeException("Không tìm thấy sản phẩm");
        }

        Product product = productOpt.get();
        product.getProductTags().clear(); // Xóa tag cũ
        if (tags != null && !tags.isEmpty()) {
            for (String tagName : tags) {
                Optional<Tag> tagOpt = tagRepository.findByTagName(tagName);
                if (tagOpt.isPresent()) {
                    product.getProductTags().add(ProductTag.builder().product(product).tag(tagOpt.get()).build());
                } else {
                    Tag newTag = Tag.builder().tagName(tagName).build();
                    tagRepository.save(newTag);
                    product.getProductTags().add(ProductTag.builder().product(product).tag(newTag).build());
                }
            }
        }
        productRepository.save(product);
        return ResponseEntity.ok(product);
    }
}
