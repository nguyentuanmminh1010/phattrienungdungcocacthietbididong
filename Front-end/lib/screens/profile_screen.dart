import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/order_provider.dart';
import '../providers/review_provider.dart';
import '../providers/address_provider.dart';
import '../providers/payment_provider.dart';
import 'my_orders_screen.dart';
import 'shipping_addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'promocodes_screen.dart';
import 'my_reviews_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userName = authService.userName ?? 'Nguyen Minh';
    final userEmail = authService.userEmail ?? 'minh@mail.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My profile',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(userEmail, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildListTile(
              context,
              title: 'My orders',
              subtitle: 'Already have ${context.watch<OrderProvider>().orders.length} orders',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen()));
              },
            ),
            _buildListTile(
              context,
              title: 'Shipping addresses',
              subtitle: '${context.watch<AddressProvider>().addresses.length} addresses',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ShippingAddressesScreen()));
              },
            ),
            _buildListTile(
              context,
              title: 'Payment methods',
              subtitle: context.watch<PaymentProvider>().defaultCard != null
                  ? 'Visa  **${context.watch<PaymentProvider>().defaultCard!.cardNumber.substring(context.watch<PaymentProvider>().defaultCard!.cardNumber.length - 2)}'
                  : 'No default card',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
              },
            ),
            _buildListTile(
              context,
              title: 'Promocodes',
              subtitle: 'You have special promocodes',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PromocodesScreen()));
              },
            ),
            _buildListTile(
              context,
              title: 'My reviews',
              subtitle: 'Reviews for ${context.watch<ReviewProvider>().reviews.length} items',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReviewsScreen()));
              },
            ),
            _buildListTile(
              context,
              title: 'Settings',
              subtitle: 'Notifications, password',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthService>().logout();
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Log out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE12B20),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required String title, required String subtitle, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
