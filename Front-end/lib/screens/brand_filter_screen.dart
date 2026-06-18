import 'package:flutter/material.dart';

class BrandFilterScreen extends StatefulWidget {
  final List<String> initialSelectedBrands;

  const BrandFilterScreen({
    super.key,
    required this.initialSelectedBrands,
  });

  @override
  State<BrandFilterScreen> createState() => _BrandFilterScreenState();
}

class _BrandFilterScreenState extends State<BrandFilterScreen> {
  late List<String> _selectedBrands;
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _allBrands = [
    'adidas',
    'adidas Originals',
    'Blend',
    'Boutique Moschino',
    'Champion',
    'Diesel',
    'Jack & Jones',
    'Naf Naf',
    'Red Valentino',
    's.Oliver',
    'Mango',
    'Zara',
    'H&M',
    'Uniqlo',
    "Levi's",
    'Nike'
  ];

  List<String> _filteredBrands = [];

  @override
  void initState() {
    super.initState();
    _selectedBrands = List.from(widget.initialSelectedBrands);
    _filteredBrands = List.from(_allBrands);
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredBrands = _allBrands.where((brand) => brand.toLowerCase().contains(query)).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.pop(context, _selectedBrands);
  }

  void _discard() {
    Navigator.pop(context, widget.initialSelectedBrands);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: _discard,
        ),
        title: const Text('Brand', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: _filteredBrands.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEBEBEB)),
                itemBuilder: (context, index) {
                  final brand = _filteredBrands[index];
                  final isSelected = _selectedBrands.contains(brand);
                  return ListTile(
                    title: Text(
                      brand,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFE12B20) : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      activeColor: const Color(0xFFE12B20),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedBrands.add(brand);
                          } else {
                            _selectedBrands.remove(brand);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedBrands.remove(brand);
                        } else {
                          _selectedBrands.add(brand);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _discard,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('Discard', style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE12B20),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
