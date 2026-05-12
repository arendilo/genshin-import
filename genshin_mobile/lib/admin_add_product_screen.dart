import 'package:flutter/material.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({Key? key}) : super(key: key);

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String _selectedType = 'Sword';
  String _selectedRarity = '5';

  bool get _isValid {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0820), Color(0xFF1A0F35), Color(0xFF2A1F4A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F35).withOpacity(0.95),
                  border: Border(bottom: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
                    ),
                    const Text('Add New Product', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Image Upload
                    _buildSectionContainer(
                      'Weapon Image',
                      Container(
                        width: double.infinity,
                        height: 128,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E143C).withOpacity(0.6),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file, color: Color(0xFFA89EC9), size: 32),
                            SizedBox(height: 8),
                            Text('Click to upload weapon image', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                            SizedBox(height: 4),
                            Text('PNG, JPG up to 5MB', style: TextStyle(color: Color(0xFF6B5BB5), fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Product Information
                    _buildSectionContainer(
                      'Product Information',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Weapon Name *', 'e.g. Primordial Jade Cutter', _nameController),
                          const SizedBox(height: 16),
                          _buildDropdown('Weapon Type *', _selectedType, ['Sword', 'Claymore', 'Polearm', 'Bow', 'Catalyst'], (val) {
                            if (val != null) setState(() => _selectedType = val);
                          }),
                          const SizedBox(height: 16),
                          _buildDropdown('Rarity *', _selectedRarity, ['3', '4', '5'], (val) {
                            if (val != null) setState(() => _selectedRarity = val);
                          }),
                          const SizedBox(height: 16),
                          _buildTextField('Description *', 'Enter weapon description...', _descriptionController, maxLines: 4),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Price (Mora) *', '4999', _priceController, isNumber: true)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField('Stock *', '10', _stockController, isNumber: true)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isValid
                                ? [const Color(0xFFD4AF37), const Color(0xFFB8941F)]
                                : [Colors.grey, Colors.grey.shade700],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isValid ? [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))] : null,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _isValid ? () => Navigator.pop(context) : null,
                          icon: const Icon(Icons.add, color: Color(0xFF1A0F35)),
                          label: const Text('Add Product', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(child: Text('* Required fields', style: TextStyle(color: Color(0xFF6B5BB5), fontSize: 14))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: Color(0xFFF5F3FF)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
            filled: true,
            fillColor: const Color(0xFF1E143C).withOpacity(0.6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E143C).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A0F35),
              style: const TextStyle(color: Color(0xFFF5F3FF)),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
