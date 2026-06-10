import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/favorite_list_card.dart';
import '../widgets/favorite_grid_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isGridView = false;
  final List<String> _tags = ["Summer", "T-Shirts", "Shirts", "Pants"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final favorites = favoriteProvider.favorites;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Favorites',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
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
              
              // List or Grid
              Expanded(
                child: favoriteProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFE12B20)))
                    : favorites.isEmpty
                        ? const Center(child: Text("You haven't added any favorites yet.", style: TextStyle(color: Colors.grey)))
                        : _isGridView
                            ? GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.53, // Adjust aspect ratio as needed
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 24,
                                ),
                                itemCount: favorites.length,
                                itemBuilder: (context, index) {
                                  final f = favorites[index];
                                  return FavoriteGridCard(
                                    favoriteId: f['id'],
                                    productId: f['productId'],
                                    imageUrl: f['imageUrl'] ?? '',
                                    brand: f['brand'] ?? 'Unknown',
                                    title: f['productName'] ?? 'Product',
                                    price: (f['salePrice'] ?? 0).toDouble(),
                                    oldPrice: f['comparePrice'] != null ? (f['comparePrice']).toDouble() : null,
                                    size: f['size'] ?? '',
                                    color: f['color'] ?? 'N/A',
                                    rating: (f['rating'] ?? 0).toDouble(),
                                    ratingCount: f['ratingCount'] ?? 0,
                                    discountTag: f['discountTag'],
                                    newTag: f['isNewBadge'] == true ? 'NEW' : null,
                                    onRemove: () => favoriteProvider.removeFavoriteById(f['id']),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: favorites.length,
                                itemBuilder: (context, index) {
                                  final f = favorites[index];
                                  return FavoriteListCard(
                                    favoriteId: f['id'],
                                    productId: f['productId'],
                                    imageUrl: f['imageUrl'] ?? '',
                                    brand: f['brand'] ?? 'Unknown',
                                    title: f['productName'] ?? 'Product',
                                    price: (f['salePrice'] ?? 0).toDouble(),
                                    oldPrice: f['comparePrice'] != null ? (f['comparePrice']).toDouble() : null,
                                    size: f['size'] ?? '',
                                    color: f['color'] ?? 'N/A',
                                    rating: (f['rating'] ?? 0).toDouble(),
                                    ratingCount: f['ratingCount'] ?? 0,
                                    discountTag: f['discountTag'],
                                    newTag: f['isNewBadge'] == true ? 'NEW' : null,
                                    onRemove: () => favoriteProvider.removeFavoriteById(f['id']),
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}
