import 'package:flutter/material.dart';
import 'brand_filter_screen.dart';

class FilterScreen extends StatefulWidget {
  final RangeValues initialPriceRange;
  final List<String> initialColors;
  final List<String> initialSizes;
  final String? initialCategory;
  final List<String> initialBrands;

  const FilterScreen({
    super.key,
    required this.initialPriceRange,
    required this.initialColors,
    required this.initialSizes,
    this.initialCategory,
    required this.initialBrands,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late RangeValues _priceRange;
  late List<String> _selectedColors;
  late List<String> _selectedSizes;
  String? _selectedCategory;
  late List<String> _selectedBrands;

  final List<String> _availableSizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<String> _availableCategories = ['All', 'Women', 'Men', 'Boys', 'Girls'];
  final Map<String, Color> _availableColors = {
    'Black': Colors.black,
    'White': Colors.white,
    'Red': const Color(0xFFB82222),
    'Grey': const Color(0xFFB0A4A4),
    'Beige': const Color(0xFFE2C8A4),
    'Navy': const Color(0xFF1B204F),
  };

  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialPriceRange;
    _selectedColors = List.from(widget.initialColors);
    _selectedSizes = List.from(widget.initialSizes);
    _selectedCategory = widget.initialCategory;
    _selectedBrands = List.from(widget.initialBrands);
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'priceRange': _priceRange,
      'colors': _selectedColors,
      'sizes': _selectedSizes,
      'category': _selectedCategory,
      'brands': _selectedBrands,
    });
  }

  void _discardFilters() {
    Navigator.pop(context, null);
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
          onPressed: _discardFilters,
        ),
        title: const Text('Filters', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader('Price range'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${_priceRange.start.toInt()}'),
                          Text('\$${_priceRange.end.toInt()}'),
                        ],
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 500,
                        activeColor: const Color(0xFFE12B20),
                        inactiveColor: Colors.grey[300],
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                        },
                      ),
                    ],
                  ),
                ),

                _buildSectionHeader('Colors'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _availableColors.entries.map((entry) {
                        final isSelected = _selectedColors.contains(entry.key);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedColors.remove(entry.key);
                              } else {
                                _selectedColors.add(entry.key);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFFE12B20) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!, width: 1),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                _buildSectionHeader('Sizes'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableSizes.map((size) {
                      final isSelected = _selectedSizes.contains(size);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedSizes.remove(size);
                            } else {
                              _selectedSizes.add(size);
                            }
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE12B20) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFFE12B20) : Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                _buildSectionHeader('Category'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableCategories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedCategory = null;
                            } else {
                              _selectedCategory = cat;
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE12B20) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFFE12B20) : Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                _buildSectionHeader('Brand'),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrandFilterScreen(
                          initialSelectedBrands: _selectedBrands,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _selectedBrands = result as List<String>;
                      });
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Brand', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            if (_selectedBrands.isNotEmpty)
                              const SizedBox(height: 4),
                            if (_selectedBrands.isNotEmpty)
                              Text(
                                _selectedBrands.join(', '),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100), // padding for bottom bar
              ],
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
                onPressed: _discardFilters,
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
                onPressed: _applyFilters,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
