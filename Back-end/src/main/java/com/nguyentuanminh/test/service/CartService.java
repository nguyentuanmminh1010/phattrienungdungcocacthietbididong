package com.nguyentuanminh.test.service;

import com.nguyentuanminh.test.dto.*;
import com.nguyentuanminh.test.entity.*;
import com.nguyentuanminh.test.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final CouponRepository couponRepository;

    @Transactional
    public CartResponse getCart(String email) {
        Cart cart = getOrCreateCart(email);
        return buildCartResponse(cart);
    }

    @Transactional
    public CartResponse addToCart(String email, CartRequest request) {
        Cart cart = getOrCreateCart(email);
        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Optional<CartItem> existingItemOpt = cartItemRepository.findByCartIdAndProductIdAndSizeAndColor(
                cart.getId(), product.getId(), request.getSize(), request.getColor());

        if (existingItemOpt.isPresent()) {
            CartItem existingItem = existingItemOpt.get();
            existingItem.setQuantity(existingItem.getQuantity() + request.getQuantity());
            cartItemRepository.save(existingItem);
        } else {
            CartItem newItem = CartItem.builder()
                    .cart(cart)
                    .product(product)
                    .quantity(request.getQuantity())
                    .size(request.getSize())
                    .color(request.getColor())
                    .priceAtAddition(product.getSalePrice())
                    .build();
            cartItemRepository.save(newItem);
        }
        return buildCartResponse(cart);
    }

    @Transactional
    public CartResponse updateQuantity(String email, Long cartItemId, int delta) {
        Cart cart = getOrCreateCart(email);
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));

        if (!item.getCart().getId().equals(cart.getId())) {
            throw new RuntimeException("Item does not belong to user's cart");
        }

        int newQty = item.getQuantity() + delta;
        if (newQty <= 0) {
            cartItemRepository.delete(item);
        } else {
            item.setQuantity(newQty);
            cartItemRepository.save(item);
        }
        return buildCartResponse(cart);
    }

    @Transactional
    public CartResponse applyCoupon(String email, String couponCode) {
        Cart cart = getOrCreateCart(email);
        
        if (couponCode == null || couponCode.trim().isEmpty()) {
            cart.setAppliedCouponCode(null);
        } else {
            Coupon coupon = couponRepository.findByCode(couponCode)
                    .orElseThrow(() -> new RuntimeException("Invalid coupon code"));
            cart.setAppliedCouponCode(coupon.getCode());
        }
        
        cart = cartRepository.save(cart);
        return buildCartResponse(cart);
    }

    public List<Coupon> getAvailableCoupons() {
        return couponRepository.findAll();
    }

    private Cart getOrCreateCart(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return cartRepository.findByUserEmail(email).orElseGet(() -> {
            Cart newCart = Cart.builder().user(user).build();
            return cartRepository.save(newCart);
        });
    }

    private CartResponse buildCartResponse(Cart cart) {
        List<CartItem> items = cartItemRepository.findByCartId(cart.getId());
        double totalAmount = 0.0;
        List<CartItemResponse> itemResponses = items.stream().map(item -> {
            CartItemResponse resp = CartItemResponse.builder()
                    .id(item.getId())
                    .productId(item.getProduct().getId())
                    .productName(item.getProduct().getProductName())
                    .imageUrl(item.getProduct().getImageUrl())
                    .price(item.getProduct().getSalePrice())
                    .brand(item.getProduct().getBrand())
                    .size(item.getSize())
                    .color(item.getColor())
                    .quantity(item.getQuantity())
                    .build();
            return resp;
        }).collect(Collectors.toList());

        for (CartItemResponse item : itemResponses) {
            totalAmount += item.getPrice() * item.getQuantity();
        }

        double totalAmountAfterDiscount = totalAmount;
        Integer discountPercentage = 0;

        if (cart.getAppliedCouponCode() != null) {
            Optional<Coupon> couponOpt = couponRepository.findByCode(cart.getAppliedCouponCode());
            if (couponOpt.isPresent()) {
                discountPercentage = couponOpt.get().getDiscountPercentage();
                totalAmountAfterDiscount = totalAmount * (1.0 - (discountPercentage / 100.0));
            } else {
                cart.setAppliedCouponCode(null);
                cartRepository.save(cart);
            }
        }

        return CartResponse.builder()
                .cartId(cart.getId())
                .items(itemResponses)
                .totalAmount(totalAmount)
                .totalAmountAfterDiscount(totalAmountAfterDiscount)
                .appliedCouponCode(cart.getAppliedCouponCode())
                .discountPercentage(discountPercentage)
                .build();
    }
}
