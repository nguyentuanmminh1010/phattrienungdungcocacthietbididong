import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '/config/api_config.dart';
import '/services/auth_service.dart';
import '../widgets/product_card.dart';
import '../providers/favorite_provider.dart';
import '../widgets/favorite_modal.dart';
import 'rating_reviews_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String title;
  final String brand;
  final String imageUrl;
  final double price;
  final double rating;
  final int ratingCount;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;
  String description = '';
  List<String> sizes = [];
  List<String> colors = [];
  List<String> imageGallery = [];
  List<dynamic> relatedProducts = [];
  bool isLoading = true;
  double _currentRating = 0.0;
  int _currentRatingCount = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
    _currentRatingCount = widget.ratingCount;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final authService = context.read<AuthService>();
      final headers = {'Authorization': 'Bearer ${authService.token}'};
      
      final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/products/${widget.productId}'), headers: headers);
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          description = data['product']['description'] ?? 'No description available.';
          _currentRating = (data['product']['rating'] as num?)?.toDouble() ?? _currentRating;
          _currentRatingCount = data['product']['ratingCount'] as int? ?? _currentRatingCount;
          sizes = List<String>.from(data['sizes'] ?? []);
          colors = List<String>.from(data['colors'] ?? []);
          imageGallery = List<String>.from(data['imageGallery'] ?? []);
          if (sizes.isNotEmpty) selectedSize = sizes.first;
          if (colors.isNotEmpty) selectedColor = colors.first;
          if (imageGallery.isEmpty) imageGallery.add(widget.imageUrl);
        });
      }

      final relatedRes = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/products/${widget.productId}/related'), headers: headers);
      if (relatedRes.statusCode == 200) {
        setState(() {
          relatedProducts = jsonDecode(utf8.decode(relatedRes.bodyBytes));
        });
      }
    } catch(e) {
      debugPrint("Error fetching details: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE CAROUSEL
            SizedBox(
              height: 400,
              child: PageView.builder(
                itemCount: imageGallery.length,
                itemBuilder: (context, index) {
                  final imgUrl = imageGallery[index];
                  return Image(
                    image: imgUrl.startsWith('http')
                        ? NetworkImage(imgUrl) as ImageProvider
                        : AssetImage(imgUrl),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // CONTROLS (Size, Color, Favorite)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _showSizeBottomSheet(),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedSize ?? 'Size', style: const TextStyle(fontSize: 14)),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedColor,
                          hint: const Text('Color'),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: colors.isEmpty
                              ? []
                              : colors.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => selectedColor = v);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFav = favoriteProvider.isFavorite(widget.productId);
                      return GestureDetector(
                        onTap: () {
                          if (isFav) {
                            favoriteProvider.removeFavoriteByProductId(widget.productId);
                          } else {
                            FavoriteModal.show(context, widget.productId);
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color(0xFFE12B20) : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // PRODUCT INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.brand,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RatingReviewsScreen(
                                  productId: widget.productId,
                                  rating: _currentRating,
                                  ratingCount: _currentRatingCount,
                                ),
                              ),
                            ).then((_) {
                              _fetchDetail(); // Refresh when returning
                            });
                          },
                          child: Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < _currentRating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFFBA49),
                                  size: 16,
                                );
                              }),
                              const SizedBox(width: 4),
                              Text(
                                '($_currentRatingCount)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // SHIPPING & SUPPORT (Collapsible sections)
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            ListTile(
              title: const Text('Shipping info'),
              trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.black),
              onTap: () {},
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            ListTile(
              title: const Text('Support'),
              trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.black),
              onTap: () {},
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),

            const SizedBox(height: 24),

            // YOU MAY ALSO LIKE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'You can also like this',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '12 items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (relatedProducts.isNotEmpty)
              SizedBox(
                height: 320,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: relatedProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final p = relatedProducts[index];
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
                ),
              ),
            
            const SizedBox(height: 40), // padding for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDB3022),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 5,
                shadowColor: const Color(0xFFDB3022).withOpacity(0.5),
              ),
              child: const Text(
                'ADD TO CART',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSizeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              height: 350,
              child: Column(
                children: [
                  Container(width: 60, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  const Text('Select size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: sizes.map((sizeStr) {
                      final isSelected = sizeStr == selectedSize;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedSize = sizeStr);
                          setModalState(() {});
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 3, // 3 columns
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE12B20) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFFE12B20) : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sizeStr,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Size info', style: TextStyle(fontSize: 16)),
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close sheet
                        // Add to cart logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB3022),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 5,
                      ),
                      child: const Text('ADD TO CART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
