import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_detail_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {})],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Text('My Orders', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: const [
                  Tab(text: 'Delivered'),
                  Tab(text: 'Processing'),
                  Tab(text: 'Cancelled'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('Delivered'),
          _buildOrderList('Processing'),
          _buildOrderList('Cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final orders = context.watch<OrderProvider>().getOrdersByStatus(status);
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
          ),
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
                children: [
                  const Text('Tracking number: ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text(order.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Quantity: ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('${order.totalQuantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Total Amount: ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('${order.totalAmount.toStringAsFixed(0)}\$', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Details', style: TextStyle(color: Colors.black)),
                  ),
                  Text(
                    order.status,
                    style: TextStyle(
                      color: order.status == 'Delivered' ? Colors.green : (order.status == 'Cancelled' ? Colors.red : Colors.orange),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
