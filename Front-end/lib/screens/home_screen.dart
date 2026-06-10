import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/widgets/product_card.dart';
import '/config/api_config.dart';
import '/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _newProducts = [];
  List<dynamic> _saleProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });
  }



  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final headers = {'Authorization': 'Bearer ${authService.token}'};
      final newRes = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/products?tag=New'), headers: headers).timeout(const Duration(seconds: 10));
      final saleRes = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/products?tag=Sale'), headers: headers).timeout(const Duration(seconds: 10));

      if (newRes.statusCode == 200) {
        _newProducts = jsonDecode(utf8.decode(newRes.bodyBytes));
      } else {
        _newProducts = [];
      }
      
      if (saleRes.statusCode == 200) {
        _saleProducts = jsonDecode(utf8.decode(saleRes.bodyBytes));
      } else {
        _saleProducts = [];
      }
    } catch (e) {
      debugPrint('Lỗi tải sản phẩm: $e');
      // Nếu lỗi (như tắt server), làm rỗng danh sách để giao diện ẩn sản phẩm đi
      _newProducts = [];
      _saleProducts = [];
    }
    setState(() => _isLoading = false);
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await context.read<AuthService>().logout();
      await GoogleSignIn.instance.disconnect();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint("Lỗi đăng xuất: $e");
    }
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  Widget _buildProductList(List<dynamic> products) {
    if (products.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Không có sản phẩm nào", style: TextStyle(color: Colors.grey))));
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        final p = products[index];
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
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Text('View all', style: TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: _fetchProducts,
      color: const Color(0xFFE12B20),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // SLIDESHOW (2/3 chiều cao màn hình)
            SizedBox(
              height: screenHeight * 0.66,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  // SLIDE 1: Fashion Sale
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/Big Banner.png',
                        width: double.infinity, height: double.infinity, fit: BoxFit.cover, alignment: Alignment.topCenter,
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0, height: 200,
                        child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent]))),
                      ),
                      const Positioned(
                        bottom: 80, left: 16,
                        child: Text('Fashion\nsale', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1.1)),
                      ),
                      Positioned(
                        bottom: 20, left: 16,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE12B20), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                          child: const Text('Check', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),

                  // SLIDE 2: Street Clothes
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/image_76fcc1ee237c.png',
                        width: double.infinity, height: double.infinity, fit: BoxFit.cover, alignment: Alignment.topCenter,
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0, height: 150,
                        child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent]))),
                      ),
                      const Positioned(
                        bottom: 20, left: 16,
                        child: Text('Street clothes', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  // SLIDE 3: New Collection
                  Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/image_74aa46d14c15.png',
                              width: double.infinity, height: double.infinity, fit: BoxFit.cover, alignment: Alignment.topCenter,
                            ),
                            Positioned(
                              bottom: 0, left: 0, right: 0, height: 150,
                              child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent]))),
                            ),
                            const Positioned(
                              bottom: 20, right: 16,
                              child: Text('New collection', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 20),
                                      child: const Text('Summer\nsale', style: TextStyle(color: Color(0xFFE12B20), fontSize: 34, fontWeight: FontWeight.bold, height: 1.1)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Image.asset('assets/images/image_0986462d6eb8.png', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                                        Positioned(
                                          bottom: 0, left: 0, right: 0, height: 80,
                                          child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent]))),
                                        ),
                                        const Positioned(bottom: 16, left: 16, child: Text('Black', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/image_1eb33472e510.png', width: double.infinity, height: double.infinity, fit: BoxFit.cover, alignment: Alignment.center),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // DANH SÁCH SẢN PHẨM Ở DƯỚI
            Container(
              color: const Color(0xFFF9F9F9),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildSectionHeader('Sale', "Super summer sale"),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280, 
                    child: _isLoading && _saleProducts.isEmpty 
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE12B20)))
                        : _buildProductList(_saleProducts),
                  ),
                  const SizedBox(height: 8),
                  _buildSectionHeader('New', "You've never seen it before!"),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280, 
                    child: _isLoading && _newProducts.isEmpty 
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE12B20)))
                        : _buildProductList(_newProducts),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Log out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE12B20),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const ShopScreen(),
      const Center(child: Text('Bag Page', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Favorites Page', style: TextStyle(fontSize: 24))),
      _buildProfileContent(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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
