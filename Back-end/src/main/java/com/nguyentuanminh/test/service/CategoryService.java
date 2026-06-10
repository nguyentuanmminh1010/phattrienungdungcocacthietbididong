package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.dto.response.CategoryDTO;
import com.nguyentuanminh.test.entity.Category;
import com.nguyentuanminh.test.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public List<CategoryDTO> getCategoryTree() {
        // Fetch top-level categories
        List<Category> topLevelCategories = categoryRepository.findByParentIsNull();
        return topLevelCategories.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    private CategoryDTO mapToDTO(Category category) {
        return CategoryDTO.builder()
                .id(category.getId())
                .categoryName(category.getCategoryName())
                .imageUrl(category.getImageUrl())
                .subCategories(
                        category.getSubCategories() != null 
                        ? category.getSubCategories().stream().map(this::mapToDTO).collect(Collectors.toList()) 
                        : null
                )
                .build();
    }
}
