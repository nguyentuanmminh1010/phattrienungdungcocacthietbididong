import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/favorite_provider.dart';
import 'favorite_modal.dart';

class ProductCard extends StatelessWidget {
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

  const ProductCard({
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
      child: SizedBox(
        width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Positioned(
                bottom: -22,
                right: 0,
                child: Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    final isFav = favoriteProvider.isFavorite(id);
                    return GestureDetector(
                      onTap: () {
                        if (isFav) {
                          favoriteProvider.removeFavoriteByProductId(id);
                        } else {
                          FavoriteModal.show(context, id);
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
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
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? const Color(0xFFE12B20) : Colors.grey,
                          size: 26,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          ),
          const SizedBox(height: 26), // Space for favorite button overlap
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
          const SizedBox(height: 4),
          Text(
            brand,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
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
                  color: Color(0xFFE12B20),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
