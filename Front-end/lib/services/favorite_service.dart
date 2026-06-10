import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> fetchFavorites() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/favorites'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFavorite(String productId, String size) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/favorites'),
      headers: headers,
      body: jsonEncode({
        'productId': productId,
        'size': size,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavorite(int favoriteId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/favorites/$favoriteId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }
}
