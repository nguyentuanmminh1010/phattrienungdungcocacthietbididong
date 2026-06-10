package com.nguyentuanminh.test.dto;

import lombok.Data;
import java.util.List;

@Data
public class ReviewDto {
    private Long id;
    private String userName;
    private String avatar;
    private Double rating;
    private String date;
    private String comment;
    private List<String> images;
}
