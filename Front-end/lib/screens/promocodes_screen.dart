import 'package:flutter/material.dart';

class PromocodesScreen extends StatefulWidget {
  const PromocodesScreen({super.key});

  @override
  State<PromocodesScreen> createState() => _PromocodesScreenState();
}

class _PromocodesScreenState extends State<PromocodesScreen> {
  final TextEditingController _promoController = TextEditingController();

  final List<Map<String, dynamic>> _mockCoupons = [
    {
      'code': 'mypromocode2020',
      'title': 'Personal offer',
      'discount': 10,
      'daysRemaining': 6,
      'image': 'https://images.unsplash.com/photo-1555529771-835f59fc5efe?auto=format&fit=crop&q=80&w=200',
    },
    {
      'code': 'summer2020',
      'title': 'Summer Sale',
      'discount': 15,
      'daysRemaining': 23,
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=200',
    },
    {
      'code': 'welcome10',
      'title': 'Welcome Bonus',
      'discount': 10,
      'daysRemaining': 30,
      'image': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&q=80&w=200',
    },
  ];

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
        title: const Text('Promocodes', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: TextField(
                      controller: _promoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your promo code',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_promoController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo code applied')));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Your Promocodes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _mockCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = _mockCoupons[index];
                  return _buildCouponCard(coupon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            child: Image.network(
              coupon['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coupon['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(coupon['code'], style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${coupon['daysRemaining']} days remaining', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Apply coupon logic
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied ${coupon['code']}!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE12B20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
