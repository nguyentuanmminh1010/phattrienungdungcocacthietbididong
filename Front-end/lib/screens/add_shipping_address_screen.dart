import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';

class AddShippingAddressScreen extends StatefulWidget {
  final Address? existingAddress;

  const AddShippingAddressScreen({super.key, this.existingAddress});

  @override
  State<AddShippingAddressScreen> createState() => _AddShippingAddressScreenState();
}

class _AddShippingAddressScreenState extends State<AddShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String address = '';
  String city = '';
  String stateRegion = '';
  String zipCode = '';
  String country = '';

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      final addr = widget.existingAddress!;
      fullName = addr.fullName;
      address = addr.address;
      city = addr.city;
      stateRegion = addr.stateRegion;
      zipCode = addr.zipCode;
      country = addr.country;
    } else {
      country = 'United States';
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Adding Shipping Address', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Full name', (val) => fullName = val!, initialValue: fullName),
              const SizedBox(height: 20),
              _buildTextField('Address', (val) => address = val!, initialValue: address),
              const SizedBox(height: 20),
              _buildTextField('City', (val) => city = val!, initialValue: city),
              const SizedBox(height: 20),
              _buildTextField('State/Province/Region', (val) => stateRegion = val!, initialValue: stateRegion),
              const SizedBox(height: 20),
              _buildTextField('Zip Code (Postal Code)', (val) => zipCode = val!, initialValue: zipCode),
              const SizedBox(height: 20),
              _buildCountryField(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newAddress = Address(
                        id: widget.existingAddress?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        fullName: fullName,
                        address: address,
                        city: city,
                        stateRegion: stateRegion,
                        zipCode: zipCode,
                        country: country,
                        isDefault: widget.existingAddress?.isDefault ?? false,
                      );
                      if (widget.existingAddress != null) {
                        context.read<AddressProvider>().updateAddress(newAddress);
                      } else {
                        context.read<AddressProvider>().addAddress(newAddress);
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE12B20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 4,
                  ),
                  child: const Text('SAVE ADDRESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, FormFieldSetter<String> onSaved, {String? initialValue}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildCountryField() {
    return GestureDetector(
      onTap: () {
        // Show a simple bottom sheet for country selection
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            final countries = ['United States', 'Việt Nam', 'United Kingdom', 'Canada', 'Australia', 'Japan'];
            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(countries[index]),
                  onTap: () {
                    setState(() {
                      country = countries[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Country', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(country.isEmpty ? 'Select Country' : country, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
