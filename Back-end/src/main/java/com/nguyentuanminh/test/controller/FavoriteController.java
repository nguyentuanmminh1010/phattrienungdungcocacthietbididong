package com.nguyentuanminh.test.controller;

import com.nguyentuanminh.test.dto.FavoriteRequest;
import com.nguyentuanminh.test.dto.FavoriteResponse;
import com.nguyentuanminh.test.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @PostMapping
    public ResponseEntity<FavoriteResponse> addFavorite(@RequestBody FavoriteRequest request, Principal principal) {
        return ResponseEntity.ok(favoriteService.addFavorite(request, principal.getName()));
    }

    @GetMapping
    public ResponseEntity<List<FavoriteResponse>> getMyFavorites(Principal principal) {
        return ResponseEntity.ok(favoriteService.getFavoritesByEmail(principal.getName()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> removeFavorite(@PathVariable Long id) {
        favoriteService.removeFavorite(id);
        return ResponseEntity.ok().build();
    }
}
