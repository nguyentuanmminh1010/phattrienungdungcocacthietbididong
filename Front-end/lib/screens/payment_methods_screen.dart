import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import 'add_payment_card_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final cards = paymentProvider.cards;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment methods', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Your payment cards', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: cards.isEmpty
                ? const Center(child: Text('No payment methods saved.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Column(
                        children: [
                          _buildCard(card),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.read<PaymentProvider>().setDefaultCard(card.id);
                                },
                                child: Icon(
                                  card.isDefault ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: card.isDefault ? Colors.black : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text('Use as default payment method', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPaymentCardScreen()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCard(PaymentCard card) {
    return Container(
      width: double.infinity,
      height: 216,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/196/196561.png',
            width: 50,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, size: 50, color: Colors.white),
          ),
          const Spacer(),
          Text(
            '**** **** **** ${card.last4}',
            style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 2),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Holder Name', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(card.nameOnCard, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expiry Date', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(card.expireDate, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
