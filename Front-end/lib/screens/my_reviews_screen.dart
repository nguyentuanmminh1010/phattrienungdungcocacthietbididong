import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/review_provider.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().fetchUserReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = context.watch<ReviewProvider>();
    final reviews = reviewProvider.reviews;
    final isLoading = reviewProvider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {})],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Text('My Reviews', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviews.isEmpty
                    ? const Center(child: Text("You haven't written any reviews yet.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return _buildReviewCard(review);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewItem review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    review.productImageUrl, 
                    width: 80, 
                    height: 80, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBarIndicator(
                            rating: review.rating,
                            itemBuilder: (context, index) => const Icon(Icons.star, color: Color(0xFFFFBA49)),
                            itemCount: 5,
                            itemSize: 16.0,
                            direction: Axis.horizontal,
                          ),
                          Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(review.comment, style: const TextStyle(fontSize: 14, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (review.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Row(
                children: review.images.map((img) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        img, 
                        width: 80, 
                        height: 80, 
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
