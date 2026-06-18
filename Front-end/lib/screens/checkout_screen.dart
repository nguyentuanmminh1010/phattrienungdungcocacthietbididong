import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/order_provider.dart';
import 'shipping_addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedDeliveryMethod = 1; // 0: FedEx, 1: USPS, 2: DHL

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final paymentProvider = context.watch<PaymentProvider>();

    final orderAmount = cartProvider.totalAmountAfterDiscount;
    final deliveryCost = 15.0; // Hardcoded delivery cost
    final summaryAmount = orderAmount + deliveryCost;

    final defaultAddress = addressProvider.defaultAddress;
    final defaultCard = paymentProvider.defaultCard;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping address
            const Text('Shipping address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(defaultAddress?.fullName ?? 'No Address Selected', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddressesScreen())),
                        child: const Text('Change', style: TextStyle(fontSize: 14, color: Color(0xFFE12B20), fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(defaultAddress?.address ?? 'Please select an address', style: const TextStyle(fontSize: 14, height: 1.5)),
                  if (defaultAddress != null)
                    Text('${defaultAddress.city}, ${defaultAddress.stateRegion} ${defaultAddress.zipCode}, ${defaultAddress.country}', style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen())),
                  child: const Text('Change', style: TextStyle(fontSize: 14, color: Color(0xFFE12B20), fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/196/196561.png',
                      width: 32,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, size: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(defaultCard != null ? '**** **** **** ${defaultCard.last4}' : 'No card selected', style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 32),

            // Delivery method
            const Text('Delivery method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDeliveryMethod(0, 'FedEx', '2-3 days', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/FedEx_Express.svg/1200px-FedEx_Express.svg.png'),
                const SizedBox(width: 16),
                _buildDeliveryMethod(1, 'USPS', '2-3 days', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/USPS_Logo.svg/1200px-USPS_Logo.svg.png'),
                const SizedBox(width: 16),
                _buildDeliveryMethod(2, 'DHL', '2-3 days', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/DHL_Logo.svg/1200px-DHL_Logo.svg.png'),
              ],
            ),
            const SizedBox(height: 48),

            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text('${orderAmount.toInt()}\$', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text('${deliveryCost.toInt()}\$', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Summary:', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${summaryAmount.toInt()}\$', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final cartProvider = context.read<CartProvider>();
                  if (cartProvider.items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty!')));
                    return;
                  }

                  if (defaultAddress == null || defaultCard == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select shipping address and payment method')),
                    );
                    return;
                  }

                  final addressProvider = context.read<AddressProvider>();
                  final defaultAddressData = addressProvider.defaultAddress;
                  final String addressStr = defaultAddressData != null ? '${defaultAddressData.address}, ${defaultAddressData.city}' : 'No address';
                  
                  final paymentProvider = context.read<PaymentProvider>();
                  final defaultPayment = paymentProvider.defaultCard;
                  final String paymentStr = defaultPayment != null ? '**** **** **** ${defaultPayment.last4}' : 'No payment method';

                  final String deliveryStr = _selectedDeliveryMethod == 0 ? 'FedEx' : (_selectedDeliveryMethod == 1 ? 'USPS' : 'DHL');

                  final newOrder = Order(
                    id: DateTime.now().millisecondsSinceEpoch.toString().substring(5),
                    trackingNumber: 'IW${DateTime.now().millisecondsSinceEpoch}',
                    date: '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}',
                    status: 'Processing',
                    shippingAddress: addressStr,
                    paymentMethod: paymentStr,
                    deliveryMethod: deliveryStr,
                    discount: 'No discount',
                    items: cartProvider.items.map((cartItem) => OrderItem(
                      id: cartItem['productId']?.toString() ?? '',
                      name: cartItem['productName'] ?? 'Product',
                      brand: cartItem['brand'] ?? 'Brand',
                      color: cartItem['color'] ?? 'N/A',
                      size: cartItem['size'] ?? 'N/A',
                      quantity: cartItem['quantity'] ?? 1,
                      price: (cartItem['price'] ?? 0).toDouble(),
                      imageUrl: cartItem['imageUrl'] ?? '',
                    )).toList(),
                  );

                  context.read<OrderProvider>().addOrder(newOrder);
                  cartProvider.clearCart();

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SuccessScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE12B20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                ),
                child: const Text('SUBMIT ORDER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethod(int index, String name, String days, String logoUrl) {
    final isSelected = _selectedDeliveryMethod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDeliveryMethod = index;
          });
        },
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? const Color(0xFFE12B20) : Colors.transparent, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(logoUrl, height: 20, fit: BoxFit.contain, errorBuilder: (c, e, s) => Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              const SizedBox(height: 8),
              Text(days, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
