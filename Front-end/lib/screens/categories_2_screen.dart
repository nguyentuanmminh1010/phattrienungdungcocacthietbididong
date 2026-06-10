import 'package:flutter/material.dart';
import 'catalog_1_screen.dart';
import 'home_screen.dart';

class Categories2Screen extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final String parentCategoryName;
  final List<dynamic> subCategories;

  const Categories2Screen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.parentCategoryName,
    required this.subCategories,
  });

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
          onPressed: () => Navigator.pop(context),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // View all items button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Catalog1Screen(
                        categoryId: categoryId,
                        categoryName: "$parentCategoryName's $categoryName",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE12B20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFFE12B20).withOpacity(0.4),
                ),
                child: const Text(
                  'VIEW ALL ITEMS',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose category',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: subCategories.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final sub = subCategories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Catalog1Screen(
                          categoryId: sub['id'],
                          categoryName: "$parentCategoryName's ${sub['categoryName']}",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    color: Colors.white,
                    child: Text(
                      sub['categoryName'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Shop tab
        onTap: (index) {
          if (index == 1) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen(initialTab: 1)));
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen(initialTab: index)),
              (route) => false,
            );
          }
        },
        selectedItemColor: const Color(0xFFE12B20),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Bag'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
