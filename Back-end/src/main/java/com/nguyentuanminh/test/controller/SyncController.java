package com.nguyentuanminh.test.controller;

import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.boot.CommandLineRunner;

@Component
public class SyncController implements CommandLineRunner {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        jdbcTemplate.execute(
                "UPDATE products p SET rating = COALESCE((SELECT AVG(rating) FROM product_reviews r WHERE r.product_id = p.id), 0), rating_count = (SELECT COUNT(*) FROM product_reviews r WHERE r.product_id = p.id);");
        System.out.println("====== SYNCHRONIZED RATINGS FROM REVIEWS ======");
    }
}
