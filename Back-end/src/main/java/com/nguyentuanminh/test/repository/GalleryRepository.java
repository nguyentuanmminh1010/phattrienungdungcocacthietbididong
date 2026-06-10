package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Gallery;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface GalleryRepository extends JpaRepository<Gallery, Long> {
}
