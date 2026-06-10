import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';

class FavoriteModal {
  static void show(BuildContext context, String productId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _FavoriteBottomSheet(productId: productId),
    );
  }
}

class _FavoriteBottomSheet extends StatefulWidget {
  final String productId;

  const _FavoriteBottomSheet({required this.productId});

  @override
  State<_FavoriteBottomSheet> createState() => _FavoriteBottomSheetState();
}

class _FavoriteBottomSheetState extends State<_FavoriteBottomSheet> {
  String _selectedSize = 'S';
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  bool _isLoading = false;

  void _addToFavorites() async {
    setState(() => _isLoading = true);
    try {
      await context.read<FavoriteProvider>().addFavorite(widget.productId, _selectedSize);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites!')),
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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _addToFavorites,
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
                      'ADD TO FAVORITES',
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
