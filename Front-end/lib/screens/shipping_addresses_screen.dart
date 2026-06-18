import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import 'add_shipping_address_screen.dart';

class ShippingAddressesScreen extends StatelessWidget {
  const ShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final addresses = addressProvider.addresses;

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
        title: const Text('Shipping Addresses', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: addresses.isEmpty
          ? const Center(child: Text('No shipping addresses saved.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
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
                          Text(addr.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddShippingAddressScreen(existingAddress: addr),
                                ),
                              );
                            },
                            child: const Text('Edit', style: TextStyle(color: Color(0xFFE12B20), fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(addr.address, style: const TextStyle(fontSize: 14, height: 1.5)),
                      Text('${addr.city}, ${addr.stateRegion} ${addr.zipCode}, ${addr.country}', style: const TextStyle(fontSize: 14, height: 1.5)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<AddressProvider>().setDefaultAddress(addr.id);
                            },
                            child: Icon(
                              addr.isDefault ? Icons.check_box : Icons.check_box_outline_blank,
                              color: addr.isDefault ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text('Use as the shipping address', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddShippingAddressScreen()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
