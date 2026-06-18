import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/promo_code_bottom_sheet.dart';
import 'checkout_screen.dart';
import 'product_detail_screen.dart';
import '../providers/favorite_provider.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'My Bag',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              
              if (cartProvider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFFE12B20))))
              else if (items.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text("Your bag is empty", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCartItem(context, item, cartProvider);
                    },
                  ),
                ),
              
              // Bottom Section
              if (items.isNotEmpty)
                Container(
                  color: const Color(0xFFF9F9F9),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Promo Code
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: cartProvider.appliedCouponCode != null
                                    ? Text(
                                        cartProvider.appliedCouponCode!,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      )
                                    : TextField(
                                        controller: _promoController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your promo code',
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                              ),
                            ),
                            if (cartProvider.appliedCouponCode != null)
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                                onPressed: () {
                                  cartProvider.applyCoupon(null);
                                  _promoController.clear();
                                },
                              )
                            else
                              GestureDetector(
                                onTap: () async {
                                  final selectedCode = await PromoCodeBottomSheet.show(context, _promoController.text);
                                  if (selectedCode != null) {
                                    cartProvider.applyCoupon(selectedCode);
                                    _promoController.text = selectedCode;
                                  } else if (_promoController.text.isNotEmpty) {
                                    cartProvider.applyCoupon(_promoController.text);
                                  }
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Total Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total amount:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          Text(
                            '${cartProvider.totalAmountAfterDiscount.toInt()}\$',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE12B20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 4,
                          ),
                          child: const Text('CHECK OUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, CartProvider cartProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: item['productId'],
              title: item['productName'] ?? 'Product',
              brand: item['brand'] ?? '',
              imageUrl: item['imageUrl'] ?? '',
              price: (item['price'] ?? 0).toDouble(),
              rating: 5.0,
              ratingCount: 10,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 104,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            child: item['imageUrl'] != null
                ? Image.network(item['imageUrl'], width: 104, height: 104, fit: BoxFit.cover)
                : Container(width: 104, height: 104, color: Colors.grey[200]),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item['productName'] ?? 'Product',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (value) {
                            if (value == 'delete') {
                              cartProvider.updateQuantity(item['id'], -item['quantity']);
                            } else if (value == 'favorite') {
                              context.read<FavoriteProvider>().addFavorite(
                                item['productId'],
                                item['size'] ?? 'M',
                              ).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added to Favorites!')),
                                );
                              }).catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error adding to favorites: $e')),
                                );
                              });
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'favorite',
                              child: Text('Add to favorites'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete from the list'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Text('Color: ${item['color'] ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 12),
                      Text('Size: ${item['size'] ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => cartProvider.updateQuantity(item['id'], -1),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                              ]),
                              child: const Icon(Icons.remove, color: Colors.grey, size: 20),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('${item['quantity']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => cartProvider.updateQuantity(item['id'], 1),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                              ]),
                              child: const Icon(Icons.add, color: Colors.black, size: 20),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${((item['price'] ?? 0) * item['quantity']).toInt()}\$',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
}
