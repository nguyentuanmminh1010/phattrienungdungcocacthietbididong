package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
}
