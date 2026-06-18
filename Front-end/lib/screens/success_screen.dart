import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Mapped graphics
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/1183/1183258.png', // Temporary placeholder for the bags icon
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, size: 100, color: Color(0xFFE12B20)),
              ),
              const SizedBox(height: 48),
              const Text('Success!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                'Your order will be delivered soon.\nThank you for choosing our app!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to HomeScreen, clearing the stack
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE12B20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 4,
                  ),
                  child: const Text('CONTINUE SHOPPING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
