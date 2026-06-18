import 'package:flutter/material.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        title: const Text('Order Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order №${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(order.date, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Tracking number: ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text(order.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Text(order.status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text('${order.items.length} items', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...order.items.map((item) => _buildOrderItem(item)),
            const SizedBox(height: 24),
            const Text('Order information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildInfoRow('Shipping Address:', order.shippingAddress),
            const SizedBox(height: 16),
            _buildInfoRow('Payment method:', order.paymentMethod, isPayment: true),
            const SizedBox(height: 16),
            _buildInfoRow('Delivery method:', order.deliveryMethod),
            const SizedBox(height: 16),
            _buildInfoRow('Discount:', order.discount),
            const SizedBox(height: 16),
            _buildInfoRow('Total Amount:', '${order.totalAmount.toStringAsFixed(0)}\$', isTotal: true),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Reorder', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE12B20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Leave feedback', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
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
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            child: Image.network(
              item.imageUrl, 
              width: 100, 
              height: 100, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100, height: 100, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(item.brand, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Color: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(item.color, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 16),
                      const Text('Size: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(item.size, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Units: ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('${item.quantity}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Text('${item.price.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPayment = false, bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(
          child: isPayment
              ? Row(
                  children: [
                    Image.network('https://cdn-icons-png.flaticon.com/512/196/196561.png', width: 32),
                    const SizedBox(width: 8),
                    Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                    fontSize: isTotal ? 16 : 14,
                  ),
                ),
        ),
      ],
    );
  }
}
