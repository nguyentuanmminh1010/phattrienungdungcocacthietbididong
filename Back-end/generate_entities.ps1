$entitiesDir = "D:\Minh\java-project\test\src\main\java\com\nguyentuanminh\test\entity"

function Write-Entity {
    param([string]$ClassName, [string]$Content)
    $path = Join-Path $entitiesDir "$ClassName.java"
    Set-Content -Path $path -Value $Content -Encoding UTF8
}

Write-Entity -ClassName "Role" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = `"roles`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Role {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = `"role_name`", length = 255, nullable = false)
    private String roleName;
    @Column(columnDefinition = `"TEXT`")
    private String privileges;
}
"@

Write-Entity -ClassName "Order" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"orders`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Order {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"coupon_id`") private UUID couponId;
    @Column(name = `"customer_id`") private UUID customerId;
    @Column(name = `"order_status_id`") private Long orderStatusId;
    @Column(name = `"order_approved_at`") private LocalDateTime orderApprovedAt;
    @Column(name = `"order_delivered_carrier_date`") private LocalDateTime orderDeliveredCarrierDate;
    @Column(name = `"order_delivered_customer_date`") private LocalDateTime orderDeliveredCustomerDate;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
}
"@

Write-Entity -ClassName "Slideshow" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"slideshows`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Slideshow {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(length = 100) private String title;
    @Column(columnDefinition = `"TEXT`") private String destinationUrl;
    @Column(columnDefinition = `"TEXT`") private String image;
    @Column(columnDefinition = `"TEXT`") private String placeholder;
    @Column(length = 255) private String description;
    @Column(name = `"btn_label`", length = 50) private String btnLabel;
    @Column(name = `"display_order`") private Integer displayOrder;
    private Boolean published;
    private Integer clicks;
    @Column(columnDefinition = `"TEXT`") private String styles; // JSON mapped to TEXT
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Entity -ClassName "ProductAttributeValue" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"product_attribute_values`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductAttributeValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_attribute_id`") private UUID productAttributeId;
    @Column(name = `"attribute_value_id`") private UUID attributeValueId;
}
"@

Write-Entity -ClassName "ShippingCountryZone" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"shipping_country_zones`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ShippingCountryZone {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"shipping_zone_id`") private Long shippingZoneId;
    @Column(name = `"country_id`") private Integer countryId;
}
"@

Write-Entity -ClassName "Sell" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"sells`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Sell {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = `"product_id`") private UUID productId;
    private Double price;
    private Integer quantity;
}
"@

Write-Entity -ClassName "Coupon" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"coupons`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Coupon {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(length = 50) private String code;
    @Column(name = `"discount_value`") private Double discountValue;
    @Column(name = `"discount_type`", length = 50) private String discountType;
    @Column(name = `"times_used`") private Integer timesUsed;
    @Column(name = `"max_usage`") private Integer maxUsage;
    @Column(name = `"order_amount_limit`") private Double orderAmountLimit;
    @Column(name = `"coupon_start_date`") private LocalDateTime couponStartDate;
    @Column(name = `"coupon_end_date`") private LocalDateTime couponEndDate;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Entity -ClassName "Gallery" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"gallery`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Gallery {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    @Column(columnDefinition = `"TEXT`") private String image;
    @Column(columnDefinition = `"TEXT`") private String placeholder;
    @Column(name = `"is_thumbnail`") private Boolean isThumbnail;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
}
"@

Write-Entity -ClassName "VariantOption" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"variant_options`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class VariantOption {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(columnDefinition = `"TEXT`") private String title;
    @Column(name = `"image_id`") private UUID imageId;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"sale_price`") private Double salePrice;
    @Column(name = `"compare_price`") private Double comparePrice;
    @Column(name = `"buying_price`") private Double buyingPrice;
    private Integer quantity;
    @Column(length = 255) private String sku;
    private Boolean active;
}
"@

Write-Entity -ClassName "Variant" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"variants`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Variant {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"variant_option`", columnDefinition = `"TEXT`") private String variantOption;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"variant_option_id`") private UUID variantOptionId;
}
"@

Write-Entity -ClassName "Notification" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"notifications`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Notification {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"account_id`") private UUID accountId;
    @Column(length = 100) private String title;
    @Column(columnDefinition = `"TEXT`") private String content;
    private Boolean seen;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"receive_time`") private LocalDateTime receiveTime;
    @Column(name = `"notification_expiry_date`") private java.time.LocalDate notificationExpiryDate;
}
"@

Write-Entity -ClassName "ProductCoupon" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"product_coupons`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductCoupon {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"coupon_id`") private UUID couponId;
}
"@

Write-Entity -ClassName "OrderStatus" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"order_statuses`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class OrderStatus {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = `"status_name`", length = 255) private String statusName;
    @Column(length = 50) private String color;
    @Column(length = 50) private String privacy;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Entity -ClassName "Country" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = `"countries`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Country {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(length = 2) private String iso;
    @Column(length = 80) private String name;
    @Column(name = `"upper_name`", length = 80) private String upperName;
    @Column(length = 3) private String iso3;
    @Column(name = `"num_code`") private Short numCode;
    @Column(name = `"phone_code`") private Integer phoneCode;
}
"@

Write-Entity -ClassName "CustomerAddress" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"customer_addresses`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class CustomerAddress {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"customer_id`") private UUID customerId;
    @Column(name = `"address_line1`", columnDefinition = `"TEXT`") private String addressLine1;
    @Column(name = `"address_line2`", columnDefinition = `"TEXT`") private String addressLine2;
    @Column(name = `"phone_number`", length = 255) private String phoneNumber;
    @Column(name = `"dial_code`", length = 50) private String dialCode;
    @Column(length = 255) private String country;
    @Column(name = `"postal_code`", length = 255) private String postalCode;
    @Column(length = 255) private String city;
}
"@

Write-Entity -ClassName "ShippingRate" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"shipping_rates`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ShippingRate {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"shipping_zone_id`") private Long shippingZoneId;
    @Column(name = `"weight_unit`", length = 50) private String weightUnit;
    @Column(name = `"min_value`") private Double minValue;
    @Column(name = `"max_value`") private Double maxValue;
    @Column(name = `"no_max`") private Boolean noMax;
    private Double price;
}
"@

Write-Entity -ClassName "Attribute" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"attributes`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Attribute {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = `"attribute_name`", length = 255) private String attributeName;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Entity -ClassName "AttributeValue" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"attribute_values`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class AttributeValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"attribute_id`") private Long attributeId;
    @Column(name = `"attribute_value`", length = 255) private String attributeValue;
    @Column(length = 50) private String color;
}
"@

Write-Entity -ClassName "ProductAttribute" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"product_attributes`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductAttribute {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"attribute_id`") private Long attributeId;
}
"@

Write-Entity -ClassName "Customer" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"customers`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Customer {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"first_name`", length = 100) private String firstName;
    @Column(name = `"last_name`", length = 100) private String lastName;
    @Column(columnDefinition = `"TEXT`") private String email;
    @Column(name = `"password_hash`", columnDefinition = `"TEXT`") private String passwordHash;
    private Boolean active;
    @Column(name = `"registered_at`") private LocalDateTime registeredAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
}
"@

Write-Entity -ClassName "ProductShippingInfo" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"product_shipping_info`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductShippingInfo {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    private Double weight;
    @Column(name = `"weight_unit`", length = 50) private String weightUnit;
    private Double volume;
    @Column(name = `"volume_unit`", length = 50) private String volumeUnit;
    @Column(name = `"dimension_width`") private Double dimensionWidth;
    @Column(name = `"dimension_height`") private Double dimensionHeight;
    @Column(name = `"dimension_depth`") private Double dimensionDepth;
    @Column(name = `"dimension_unit`", length = 50) private String dimensionUnit;
}
"@

Write-Entity -ClassName "VariantValue" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"variant_values`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class VariantValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"variant_id`") private UUID variantId;
    @Column(name = `"product_attribute_value_id`") private UUID productAttributeValueId;
}
"@

Write-Entity -ClassName "Card" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"cards`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Card {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"customer_id`") private UUID customerId;
}
"@

Write-Entity -ClassName "ShippingZone" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"shipping_zones`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ShippingZone {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(length = 255) private String name;
    @Column(name = `"display_name`", length = 255) private String displayName;
    private Boolean active;
    @Column(name = `"free_shipping`") private Boolean freeShipping;
    @Column(name = `"rate_type`", length = 50) private String rateType;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Entity -ClassName "OrderItem" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"order_items`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class OrderItem {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"order_id`") private UUID orderId; // NOTE: varchar(50) in DB but generally UUID is used for orders. Will use String if varchar(50)
    private Double price;
    private Integer quantity;
}
"@

Write-Entity -ClassName "CartItem" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"cart_items`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class CartItem {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"card_id`") private UUID cardId;
    @Column(name = `"product_id`") private UUID productId;
    private Integer quantity;
}
"@

Write-Entity -ClassName "ProductSupplier" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Entity @Table(name = `"product_suppliers`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductSupplier {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"product_id`") private UUID productId;
    @Column(name = `"supplier_id`") private UUID supplierId;
}
"@

Write-Entity -ClassName "Supplier" -Content @"
package com.nguyentuanminh.test.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;
@Entity @Table(name = `"suppliers`") @Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Supplier {
    @Id @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @Column(name = `"supplier_name`", length = 255) private String supplierName;
    @Column(length = 255) private String company;
    @Column(name = `"phone_number`", length = 255) private String phoneNumber;
    @Column(name = `"address_line1`", columnDefinition = `"TEXT`") private String addressLine1;
    @Column(name = `"address_line2`", columnDefinition = `"TEXT`") private String addressLine2;
    @Column(name = `"country_id`") private Integer countryId;
    @Column(length = 255) private String city;
    @Column(columnDefinition = `"TEXT`") private String note;
    @Column(name = `"created_at`") private LocalDateTime createdAt;
    @Column(name = `"updated_at`") private LocalDateTime updatedAt;
    @Column(name = `"created_by`") private UUID createdBy;
    @Column(name = `"updated_by`") private UUID updatedBy;
}
"@

Write-Host "Entities generated successfully."
