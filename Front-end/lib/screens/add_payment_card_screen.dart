import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';

class AddPaymentCardScreen extends StatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String nameOnCard = '';
  String cardNumber = '';
  String expireDate = '';
  String cvv = '';
  bool setAsDefault = false;

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
        title: const Text('Add new card', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Name on card', (val) => nameOnCard = val!),
              const SizedBox(height: 20),
              _buildTextField('Card number', (val) => cardNumber = val!, isNumber: true, suffixIcon: const Icon(Icons.credit_card, color: Colors.grey)),
              const SizedBox(height: 20),
              _buildTextField('Expire Date', (val) => expireDate = val!),
              const SizedBox(height: 20),
              _buildTextField('CVV', (val) => cvv = val!, isNumber: true),
              const SizedBox(height: 32),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        setAsDefault = !setAsDefault;
                      });
                    },
                    child: Icon(
                      setAsDefault ? Icons.check_box : Icons.check_box_outline_blank,
                      color: setAsDefault ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Set as default payment method', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newCard = PaymentCard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nameOnCard: nameOnCard,
                        cardNumber: cardNumber,
                        expireDate: expireDate,
                        cvv: cvv,
                        isDefault: setAsDefault,
                      );
                      context.read<PaymentProvider>().addCard(newCard);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE12B20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 4,
                  ),
                  child: const Text('ADD CARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, FormFieldSetter<String> onSaved, {bool isNumber = false, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: suffixIcon,
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }
}
