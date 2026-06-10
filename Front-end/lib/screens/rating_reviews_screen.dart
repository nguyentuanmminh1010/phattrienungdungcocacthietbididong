import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '/config/api_config.dart';
import '/services/auth_service.dart';

class RatingReviewsScreen extends StatefulWidget {
  final String productId;
  final double rating;
  final int ratingCount;

  const RatingReviewsScreen({
    super.key,
    required this.productId,
    required this.rating,
    required this.ratingCount,
  });

  @override
  State<RatingReviewsScreen> createState() => _RatingReviewsScreenState();
}

class _RatingReviewsScreenState extends State<RatingReviewsScreen> {
  bool _withPhoto = false;
  List<dynamic> _reviews = []; 
  bool _isLoading = true;
  double _averageRating = 0.0;
  int _totalRatings = 0;

  @override
  void initState() {
    super.initState();
    _averageRating = widget.rating;
    _totalRatings = widget.ratingCount;
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final headers = {'Authorization': 'Bearer ${authService.token}'};
      final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/reviews/${widget.productId}'), headers: headers);
      if (res.statusCode == 200) {
        setState(() {
          _reviews = jsonDecode(utf8.decode(res.bodyBytes));
          _totalRatings = _reviews.length;
          if (_totalRatings > 0) {
            double sum = 0;
            for (var r in _reviews) {
              sum += (r['rating'] as num?)?.toDouble() ?? 0.0;
            }
            _averageRating = sum / _totalRatings;
          } else {
            _averageRating = 0.0;
          }
        });
      }
    } catch(e) {
      debugPrint("Error fetching reviews: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showWriteReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewBottomSheet(
        productId: widget.productId,
        onReviewSubmitted: _fetchReviews,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0xFFF9F9F9),
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  expandedHeight: 120,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top + 10;
                      return FlexibleSpaceBar(
                        centerTitle: isCollapsed,
                        titlePadding: isCollapsed 
                            ? const EdgeInsets.only(bottom: 16) 
                            : const EdgeInsets.only(left: 16, bottom: 16),
                        title: const Text(
                          'Rating&Reviews',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 80), // padding for FAB
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = _reviews[index];
                        List<dynamic> images = review['images'] != null ? (review['images'] as List) : [];
                        if (_withPhoto && images.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return _buildReviewCard(review);
                      },
                      childCount: _reviews.length,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showWriteReviewSheet,
        backgroundColor: const Color(0xFFE12B20),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('Write a review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    int totalReviews = _reviews.length;
    List<int> starCounts = [0, 0, 0, 0, 0]; // 1, 2, 3, 4, 5
    for (var review in _reviews) {
      double r = (review['rating'] as num?)?.toDouble() ?? 0.0;
      if (r >= 4.5) { starCounts[4]++; }
      else if (r >= 3.5) { starCounts[3]++; }
      else if (r >= 2.5) { starCounts[2]++; }
      else if (r >= 1.5) { starCounts[1]++; }
      else { starCounts[0]++; }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFF9F9F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.2)),
                  Text('$_totalRatings ratings', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final stars = 5 - index;
                    final count = starCounts[stars - 1];
                    final fraction = totalReviews == 0 ? 0.0 : count / totalReviews;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(stars, (_) => const Icon(Icons.star, size: 14, color: Color(0xFFFFBA49))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: fraction,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE12B20),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            child: Text('$count', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_reviews.length} reviews', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Checkbox(
                    value: _withPhoto,
                    activeColor: const Color(0xFFE12B20),
                    onChanged: (val) {
                      setState(() => _withPhoto = val ?? false);
                    },
                  ),
                  const Text('With photo', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    List<dynamic> images = review['images'] != null ? (review['images'] as List) : [];
    String avatarUrl = review['avatar'] ?? 'assets/images/user1.png';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, left: 32, right: 16, bottom: 8),
          padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(review['userName'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBarIndicator(
                    rating: (review['rating'] as num?)?.toDouble() ?? 0.0,
                    itemBuilder: (context, index) => const Icon(Icons.star, color: Color(0xFFFFBA49)),
                    itemCount: 5,
                    itemSize: 14.0,
                    direction: Axis.horizontal,
                  ),
                  Text(review['date'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(review['comment'] ?? '', style: const TextStyle(height: 1.5, fontSize: 14)),
              if (images.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      String imgUrl = images[idx].toString();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: imgUrl.startsWith('http') 
                          ? Image.network(imgUrl, width: 104, height: 104, fit: BoxFit.cover)
                          : Image.asset('assets/images/image_74aa46d14c15.png', width: 104, height: 104, fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Helpful', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 8),
                  Icon(Icons.thumb_up, color: Colors.grey.shade400, size: 16),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: avatarUrl.startsWith('http')
                ? NetworkImage(avatarUrl) as ImageProvider
                : AssetImage(avatarUrl.isEmpty ? 'assets/images/user1.png' : avatarUrl),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}

class WriteReviewBottomSheet extends StatefulWidget {
  final String productId;
  final VoidCallback onReviewSubmitted;
  const WriteReviewBottomSheet({super.key, required this.productId, required this.onReviewSubmitted});

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0 || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide rating and comment')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final authService = context.read<AuthService>();
      var request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/api/reviews/${widget.productId}'));
      request.headers['Authorization'] = 'Bearer ${authService.token}';
      request.fields['rating'] = _rating.toString();
      request.fields['comment'] = _commentController.text;

      for (var file in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images', file.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted!')));
          widget.onReviewSubmitted();
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit review')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 60, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('What is your rate?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              unratedColor: Colors.grey.shade300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Color(0xFFFFBA49)),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            const SizedBox(height: 24),
            const Text('Please share your opinion\nabout the product', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Your review',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE12B20)),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        const Text('Add your photos', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(_selectedImages[index].path), width: 104, height: 104, fit: BoxFit.cover),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB3022),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 5,
                ),
                child: _isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('SEND REVIEW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
