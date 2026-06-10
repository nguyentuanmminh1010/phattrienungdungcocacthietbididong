import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

class ProductListCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String brand;
  final String title;
  final double price;
  final double? oldPrice;
  final int ratingCount;
  final double rating;
  final String? discountTag;
  final String? newTag;

  const ProductListCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.price,
    this.oldPrice,
    required this.ratingCount,
    required this.rating,
    this.discountTag,
    this.newTag,
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
              productId: id,
              title: title,
              brand: brand,
              imageUrl: imageUrl,
              price: price,
              rating: rating,
              ratingCount: ratingCount,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        height: 120,
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
          Row(
            children: [
              // Image Left
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  width: 110,
                  height: 120,
                  child: imageUrl.startsWith('http')
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
              // Content Right
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        brand,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
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
                          const SizedBox(width: 4),
                          Text('($ratingCount)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
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
                            style: const TextStyle(
                              color: Colors.black, // Depending on the design
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          // Favorite Button Overflowing
          Positioned(
            bottom: -15,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
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
                Icons.favorite_border,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
