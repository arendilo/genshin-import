import 'package:flutter/material.dart';

class AdminEditProductScreen extends StatefulWidget {
  final int weaponId;

  const AdminEditProductScreen({Key? key, required this.weaponId}) : super(key: key);

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Primordial Jade Cutter');
  final TextEditingController _descriptionController = TextEditingController(text: 'A ceremonial sword masterfully crafted from pure jade. It has a faint, ethereal glow that seems to transcend the boundaries of this world.');
  final TextEditingController _priceController = TextEditingController(text: '4999');
  final TextEditingController _stockController = TextEditingController(text: '12');
  String _selectedType = 'Sword';
  String _selectedRarity = '5';

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E143C),
        title: const Text('Delete Weapon', style: TextStyle(color: Color(0xFFD4183D))),
        content: const Text('Are you sure you want to delete this weapon?', style: TextStyle(color: Color(0xFFF5F3FF))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFA89EC9))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Go back to dashboard
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFD4183D))),
          ),
        ],
      ),
    );
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
                    const Text('Edit Product', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    GestureDetector(
                      onTap: _handleDelete,
                      child: const Icon(Icons.delete, color: Color(0xFFD4183D)),
                    ),
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
                      Row(
                        children: [
                          Container(
                            width: 96, height: 96,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E143C).withOpacity(0.6),
                              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Text('🗡️', style: TextStyle(fontSize: 48))),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.upload_file, color: Color(0xFFD4AF37)),
                              label: const Text('Upload New Image', style: TextStyle(color: Color(0xFFD4AF37))),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                                backgroundColor: const Color(0xFF1E143C).withOpacity(0.6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Product Information
                    _buildSectionContainer(
                      'Product Information',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Weapon Name', _nameController),
                          const SizedBox(height: 16),
                          _buildDropdown('Weapon Type', _selectedType, ['Sword', 'Claymore', 'Polearm', 'Bow', 'Catalyst'], (val) {
                            if (val != null) setState(() => _selectedType = val);
                          }),
                          const SizedBox(height: 16),
                          _buildDropdown('Rarity', _selectedRarity, ['3', '4', '5'], (val) {
                            if (val != null) setState(() => _selectedRarity = val);
                          }),
                          const SizedBox(height: 16),
                          _buildTextField('Description', _descriptionController, maxLines: 4),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Price (Mora)', _priceController, isNumber: true)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField('Stock', _stockController, isNumber: true)),
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
                          gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.save, color: Color(0xFF1A0F35)),
                          label: const Text('Save Changes', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Color(0xFFF5F3FF)),
          decoration: InputDecoration(
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
