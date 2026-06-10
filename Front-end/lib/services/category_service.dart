import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config/api_config.dart';

class CategoryService {
  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/categories')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
