import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class AddToCartModal {
  static void show(BuildContext context, String productId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _AddToCartBottomSheet(productId: productId),
    );
  }
}

class _AddToCartBottomSheet extends StatefulWidget {
  final String productId;

  const _AddToCartBottomSheet({required this.productId});

  @override
  State<_AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<_AddToCartBottomSheet> {
  String _selectedSize = 'M';
  String _selectedColor = 'Black';
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final Map<String, Color> _colors = {
    'Black': Colors.black,
    'White': Colors.white,
    'Red': const Color(0xFFB82222),
    'Grey': const Color(0xFFB0A4A4),
    'Beige': const Color(0xFFE2C8A4),
    'Navy': const Color(0xFF1B204F),
  };
  bool _isLoading = false;

  void _addToCart() async {
    setState(() => _isLoading = true);
    try {
      await context.read<CartProvider>().addToCart(widget.productId, 1, _selectedSize, _selectedColor);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Cart!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select size',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _sizes.map((size) {
                final isSelected = _selectedSize == size;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSize = size;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE12B20) : Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFE12B20) : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        size,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select color',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _colors.entries.map((entry) {
                final isSelected = _selectedColor == entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = entry.key;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFE12B20) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: entry.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE12B20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'ADD TO CART',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
