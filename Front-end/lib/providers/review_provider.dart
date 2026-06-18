import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ReviewItem {
  final String id;
  final String productId;
  final String productName;
  final String productImageUrl;
  final double rating;
  final String date;
  final String comment;
  final List<String> images;

  ReviewItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.rating,
    required this.date,
    required this.comment,
    this.images = const [],
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'].toString(),
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? 'Product',
      productImageUrl: json['productImageUrl'] ?? 'https://via.placeholder.com/150',
      rating: (json['rating'] ?? 0.0).toDouble(),
      date: json['date'] ?? '',
      comment: json['comment'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class ReviewProvider with ChangeNotifier {
  List<ReviewItem> _reviews = [];
  bool _isLoading = false;

  List<ReviewItem> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> fetchUserReviews() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) return;

      final res = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/reviews/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
        _reviews = data.map((e) => ReviewItem.fromJson(e)).toList();
      } else {
        if (kDebugMode) print("Failed to load user reviews");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching user reviews: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
