package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Slideshow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface SlideshowRepository extends JpaRepository<Slideshow, Long> {
}
