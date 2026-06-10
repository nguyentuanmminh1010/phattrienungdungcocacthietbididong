import 'package:flutter/material.dart';
import '/services/category_service.dart';
import 'categories_2_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  final CategoryService _categoryService = CategoryService();
  List<dynamic> _categories = [];
  bool _isLoading = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
        if (_categories.isNotEmpty) {
          _tabController = TabController(length: _categories.length, vsync: this);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: (_isLoading || _categories.isEmpty) ? null : TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFE12B20),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: _categories.map((c) => Tab(text: c['categoryName'])).toList(),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE12B20)))
        : _categories.isEmpty
            ? const Center(child: Text('Không tải được danh mục', style: TextStyle(color: Colors.grey)))
            : TabBarView(
                controller: _tabController,
                children: _categories.map((c) {
                  final subCategories = c['subCategories'] ?? [];
                  return _buildCategoryTab(c['categoryName'], subCategories);
                }).toList(),
              ),
    );
  }

  Widget _buildCategoryTab(String parentCategoryName, List<dynamic> subCategories) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Banner is approx 100px height, cards are 100px.
        double fixedContentHeight = 100.0 + (subCategories.length * 100.0);
        int numberOfGaps = subCategories.length + 2; // Above banner, below banner, and below each card
        double minTotalGapsHeight = numberOfGaps * 16.0;
        
        double extraSpace = constraints.maxHeight - (fixedContentHeight + minTotalGapsHeight);
        
        // Allow gap to shrink slightly if the screen is just a tiny bit too short, to avoid having to scroll "a little bit"
        double gap = 16.0 + (extraSpace / numberOfGaps);
        if (gap < 12.0) {
          gap = 12.0; // Enforce a minimum gap of 12px. If it still doesn't fit, it will scroll normally.
        }

        List<Widget> children = [
          SizedBox(height: gap),
          // Summer Sales Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFE12B20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: const [
                Text(
                  'SUMMER SALES',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Up to 50% off',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: gap),
        ];

        for (int i = 0; i < subCategories.length; i++) {
          children.add(_buildCategoryCard(parentCategoryName, subCategories[i]));
          children.add(SizedBox(height: gap));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: children,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(String parentCategoryName, dynamic category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Categories2Screen(
              categoryId: category['id'],
              categoryName: category['categoryName'],
              parentCategoryName: parentCategoryName,
              subCategories: category['subCategories'] ?? [],
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    category['categoryName'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (category['imageUrl'] != null)
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: category['imageUrl'].toString().startsWith('http')
                      ? Image.network(
                          category['imageUrl'],
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        )
                      : Image.asset(
                          category['imageUrl'],
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
