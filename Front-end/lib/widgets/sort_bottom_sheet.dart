import 'package:flutter/material.dart';

class SortBottomSheet extends StatelessWidget {
  final String currentSort;
  
  const SortBottomSheet({super.key, required this.currentSort});

  static Future<String?> show(BuildContext context, String currentSort) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SortBottomSheet(currentSort: currentSort),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Popular',
      'Newest',
      'Customer review',
      'Price: lowest to high',
      'Price: highest to low',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort by',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...sortOptions.map((option) {
            final isSelected = option == currentSort;
            return InkWell(
              onTap: () {
                Navigator.pop(context, option);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: isSelected ? const Color(0xFFE12B20) : Colors.transparent,
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
