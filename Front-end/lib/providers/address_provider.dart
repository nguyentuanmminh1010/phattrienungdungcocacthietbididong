import 'package:flutter/foundation.dart';

class Address {
  final String id;
  final String fullName;
  final String address;
  final String city;
  final String stateRegion;
  final String zipCode;
  final String country;
  bool isDefault;

  Address({
    required this.id,
    required this.fullName,
    required this.address,
    required this.city,
    required this.stateRegion,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });
}

class AddressProvider with ChangeNotifier {
  final List<Address> _addresses = [
    Address(
      id: '1',
      fullName: 'Jane Doe',
      address: '3 Newbridge Court',
      city: 'Chino Hills',
      stateRegion: 'CA',
      zipCode: '91709',
      country: 'United States',
      isDefault: true,
    ),
    Address(
      id: '2',
      fullName: 'John Doe',
      address: '3 Newbridge Court',
      city: 'Chino Hills',
      stateRegion: 'CA',
      zipCode: '91709',
      country: 'United States',
      isDefault: false,
    ),
  ];

  List<Address> get addresses => _addresses;
  Address? get defaultAddress => _addresses.cast<Address?>().firstWhere((addr) => addr?.isDefault == true, orElse: () => null);

  void addAddress(Address address) {
    if (address.isDefault || _addresses.isEmpty) {
      for (var a in _addresses) {
        a.isDefault = false;
      }
      address.isDefault = true;
    }
    _addresses.add(address);
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    for (var a in _addresses) {
      a.isDefault = a.id == id;
    }
    notifyListeners();
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      if (updatedAddress.isDefault) {
        setDefaultAddress(updatedAddress.id);
      }
      notifyListeners();
    }
  }
}
