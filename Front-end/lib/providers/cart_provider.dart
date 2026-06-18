import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class CartProvider with ChangeNotifier {
  List<dynamic> _items = [];
  double _totalAmount = 0.0;
  double _totalAmountAfterDiscount = 0.0;
  String? _appliedCouponCode;
  int _discountPercentage = 0;
  bool _isLoading = false;

  List<dynamic> get items => _items;
  double get totalAmount => _totalAmount;
  double get totalAmountAfterDiscount => _totalAmountAfterDiscount;
  String? get appliedCouponCode => _appliedCouponCode;
  int get discountPercentage => _discountPercentage;
  bool get isLoading => _isLoading;

  String get _baseUrl => '${ApiConfig.baseUrl}/api/cart';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _parseCartData(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching cart: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(String productId, int quantity, String size, String color) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('$_baseUrl/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': productId,
          'quantity': quantity,
          'size': size,
          'color': color,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _parseCartData(data);
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error adding to cart: $e");
      }
      rethrow;
    }
  }

  Future<void> updateQuantity(int itemId, int delta) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('$_baseUrl/items/$itemId?delta=$delta'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _parseCartData(data);
      } else {
        throw Exception('Failed to update quantity: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating quantity: $e");
      }
      rethrow;
    }
  }

  Future<void> applyCoupon(String? code) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final uri = code != null && code.isNotEmpty 
          ? Uri.parse('$_baseUrl/apply-coupon?code=$code')
          : Uri.parse('$_baseUrl/apply-coupon');

      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _parseCartData(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error applying coupon: $e");
      }
    }
  }

  Future<List<dynamic>> fetchAvailableCoupons() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$_baseUrl/coupons'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching coupons: $e");
      }
    }
    return [];
  }

  void _parseCartData(Map<String, dynamic> data) {
    _items = data['items'] ?? [];
    _totalAmount = (data['totalAmount'] ?? 0.0).toDouble();
    _totalAmountAfterDiscount = (data['totalAmountAfterDiscount'] ?? 0.0).toDouble();
    _appliedCouponCode = data['appliedCouponCode'];
    _discountPercentage = data['discountPercentage'] ?? 0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _totalAmount = 0.0;
    _totalAmountAfterDiscount = 0.0;
    _appliedCouponCode = null;
    _discountPercentage = 0;
    notifyListeners();
  }
}
