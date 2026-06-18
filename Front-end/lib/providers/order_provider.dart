import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String name;
  final String brand;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class Order {
  final String id;
  final String trackingNumber;
  final String date;
  final String status; // 'Delivered', 'Processing', 'Cancelled'
  final List<OrderItem> items;
  final String shippingAddress;
  final String paymentMethod;
  final String deliveryMethod;
  final String discount;

  Order({
    required this.id,
    required this.trackingNumber,
    required this.date,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.discount,
  });

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status == status).toList();
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
