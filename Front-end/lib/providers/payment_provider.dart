import 'package:flutter/foundation.dart';

class PaymentCard {
  final String id;
  final String nameOnCard;
  final String cardNumber;
  final String expireDate;
  final String cvv;
  bool isDefault;

  PaymentCard({
    required this.id,
    required this.nameOnCard,
    required this.cardNumber,
    required this.expireDate,
    required this.cvv,
    this.isDefault = false,
  });

  String get last4 {
    if (cardNumber.length >= 4) {
      return cardNumber.substring(cardNumber.length - 4);
    }
    return cardNumber;
  }
}

class PaymentProvider with ChangeNotifier {
  final List<PaymentCard> _cards = [
    PaymentCard(
      id: '1',
      nameOnCard: 'Jennyfer Doe',
      cardNumber: '1234567890123947',
      expireDate: '05/23',
      cvv: '123',
      isDefault: true,
    ),
  ];

  List<PaymentCard> get cards => _cards;
  PaymentCard? get defaultCard => _cards.cast<PaymentCard?>().firstWhere((card) => card?.isDefault == true, orElse: () => null);

  void addCard(PaymentCard card) {
    if (card.isDefault || _cards.isEmpty) {
      for (var c in _cards) {
        c.isDefault = false;
      }
      card.isDefault = true;
    }
    _cards.add(card);
    notifyListeners();
  }

  void setDefaultCard(String id) {
    for (var c in _cards) {
      c.isDefault = c.id == id;
    }
    notifyListeners();
  }
}
