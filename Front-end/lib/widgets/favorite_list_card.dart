import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

class FavoriteListCard extends StatelessWidget {
  final int favoriteId;
  final String productId;
  final String imageUrl;
  final String brand;
  final String title;
  final double price;
  final double? oldPrice;
  final String size;
  final String color;
  final double rating;
  final int ratingCount;
  final String? discountTag;
  final String? newTag;
  final VoidCallback onRemove;

  const FavoriteListCard({
    super.key,
    required this.favoriteId,
    required this.productId,
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.size,
    required this.color,
    required this.rating,
    required this.ratingCount,
    this.discountTag,
    this.newTag,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: productId,
              brand: brand,
              imageUrl: imageUrl,
              title: title,
              price: price,
              rating: rating,
              ratingCount: ratingCount,
            ),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 114,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: 104,
                    height: 114,
                    child: imageUrl.startsWith('http')
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : Image.asset(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                brand,
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ),
                            GestureDetector(
                              onTap: onRemove,
                              child: const Icon(Icons.close, color: Colors.grey, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Color: $color',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Size: $size',
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (oldPrice != null) ...[
                                  Text(
                                    '${oldPrice!.toStringAsFixed(0)}\$',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  '${price.toStringAsFixed(0)}\$',
                                  style: TextStyle(
                                    color: oldPrice != null ? const Color(0xFFE12B20) : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < rating.floor() ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 14,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 2),
                                Text('($ratingCount)', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                const SizedBox(width: 16), // space for overlapping bag icon
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Badges
          if (discountTag != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE12B20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  discountTag!,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (newTag != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  newTag!,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          // Red Bag Button
          Positioned(
            bottom: 6, // 24 (margin) - 18
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE12B20),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
