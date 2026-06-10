import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '/config/api_config.dart';
import '/services/auth_service.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_card.dart';

class Catalog1Screen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const Catalog1Screen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<Catalog1Screen> createState() => _Catalog1ScreenState();
}

class _Catalog1ScreenState extends State<Catalog1Screen> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  bool _isGridView = false; // By default list view according to Catalog 1

  // Placeholder tags for the top scrollable row matching the design
  final List<String> _tags = ["T-shirts", "Crop tops", "Blouses", "Sleeveless", "Shirts"];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final headers = {'Authorization': 'Bearer ${authService.token}'};
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/products?categoryId=${widget.categoryId}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          _products = jsonDecode(utf8.decode(response.bodyBytes));
        });
      } else {
        debugPrint('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        title: _isGridView 
            ? Text(widget.categoryName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
            : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Huge Title (only in List View)
          if (!_isGridView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.categoryName,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          if (!_isGridView)
            const SizedBox(height: 16),
          // Scrollable Tags Row
          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _tags[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Filter & Sort Row
          Container(
            color: const Color(0xFFF9F9F9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list, size: 20),
                      SizedBox(width: 8),
                      Text('Filters', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.swap_vert, size: 20),
                      SizedBox(width: 8),
                      Text('Price: lowest to high', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view, size: 24),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product List / Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text("Không có sản phẩm nào"))
                    : _isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final p = _products[index];
                              return ProductCard(
                                id: p['id'] ?? '',
                                imageUrl: p['imageUrl'] ?? '',
                                brand: p['brand'] ?? 'Unknown',
                                title: p['productName'] ?? 'Product',
                                price: (p['salePrice'] ?? 0).toDouble(),
                                oldPrice: p['comparePrice'] != null ? (p['comparePrice']).toDouble() : null,
                                ratingCount: p['ratingCount'] ?? 0,
                                rating: (p['rating'] ?? 0).toDouble(),
                                discountTag: p['discountTag'],
                                newTag: p['isNewBadge'] == true ? 'NEW' : null,
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final p = _products[index];
                              return ProductListCard(
                                id: p['id'] ?? '',
                                imageUrl: p['imageUrl'] ?? '',
                                brand: p['brand'] ?? 'Unknown',
                                title: p['productName'] ?? 'Product',
                                price: (p['salePrice'] ?? 0).toDouble(),
                                oldPrice: p['comparePrice'] != null ? (p['comparePrice']).toDouble() : null,
                                ratingCount: p['ratingCount'] ?? 0,
                                rating: (p['rating'] ?? 0).toDouble(),
                                discountTag: p['discountTag'],
                                newTag: p['isNewBadge'] == true ? 'NEW' : null,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
