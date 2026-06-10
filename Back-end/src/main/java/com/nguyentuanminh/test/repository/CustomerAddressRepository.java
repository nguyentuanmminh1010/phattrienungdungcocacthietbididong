package com.nguyentuanminh.test.repository;

import com.nguyentuanminh.test.entity.CustomerAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, Long> {
}
