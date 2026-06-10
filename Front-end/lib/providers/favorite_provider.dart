import 'package:flutter/material.dart';
import '../services/favorite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _favoriteService = FavoriteService();
  List<dynamic> _favorites = [];
  bool _isLoading = false;

  List<dynamic> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteProvider() {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favorites = await _favoriteService.fetchFavorites();
    } catch (e) {
      debugPrint('Error fetching favorites in provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    return _favorites.any((f) => f['productId'] == productId);
  }

  Future<void> addFavorite(String productId, String size) async {
    try {
      await _favoriteService.addFavorite(productId, size);
      // Fetch again to get the updated list including the new favoriteId
      await fetchFavorites();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavoriteByProductId(String productId) async {
    try {
      final favorite = _favorites.firstWhere((f) => f['productId'] == productId, orElse: () => null);
      if (favorite != null) {
        await _favoriteService.removeFavorite(favorite['id']);
        _favorites.removeWhere((f) => f['productId'] == productId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing favorite by productId: $e');
      rethrow;
    }
  }

  Future<void> removeFavoriteById(int favoriteId) async {
    try {
      await _favoriteService.removeFavorite(favoriteId);
      _favorites.removeWhere((f) => f['id'] == favoriteId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite by ID: $e');
      rethrow;
    }
  }
}
