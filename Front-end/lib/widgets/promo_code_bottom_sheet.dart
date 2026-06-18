import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PromoCodeBottomSheet extends StatefulWidget {
  final String initialCode;

  const PromoCodeBottomSheet({super.key, required this.initialCode});

  static Future<String?> show(BuildContext context, String initialCode) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PromoCodeBottomSheet(initialCode: initialCode),
    );
  }

  @override
  State<PromoCodeBottomSheet> createState() => _PromoCodeBottomSheetState();
}

class _PromoCodeBottomSheetState extends State<PromoCodeBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialCode;
    _fetchCoupons();
  }

  Future<void> _fetchCoupons() async {
    final provider = context.read<CartProvider>();
    final coupons = await provider.fetchAvailableCoupons();
    if (mounted) {
      setState(() {
        _coupons = coupons;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7 + keyboardHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Center(
            child: Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter your promo code',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      Navigator.pop(context, _controller.text);
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
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Your Promo Codes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE12B20)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = _coupons[index];
                    return _buildPromoCard(coupon);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(dynamic coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Left Red Block
          Container(
            width: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE12B20),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${coupon['discountPercentage']}',
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, height: 1),
                  ),
                  const Text(
                    '% off',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          
          // Right Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(coupon['title'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(coupon['code'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${coupon['daysRemaining']} days remaining', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      SizedBox(
                        width: 90,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, coupon['code']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE12B20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Apply', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
