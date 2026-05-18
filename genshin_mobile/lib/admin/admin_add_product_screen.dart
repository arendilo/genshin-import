import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart'; // Ditambahkan untuk ambil token

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

  XFile? _pickedFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedFile = image;
      });
    }
  }

  bool get _isValid {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty &&
        _pickedFile != null;
  }

  // ==============================================================
  // LOGIKA ADD PRODUCT DENGAN TOKEN JWT
  // ==============================================================
  Future<void> _addProduct() async {
    if (!_isValid) {
      _showSnackBar('Please fill all fields and pick an image!', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Ambil Token dari memori HP
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final String baseUrl = kIsWeb
          ? 'http://127.0.0.1:3000'
          : 'http://10.0.2.2:3000';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products'),
      );

      // 2. Selipkan Token ke Header (Syarat Dosen)
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['name'] = _nameController.text.trim();
      request.fields['type'] = _selectedType;
      request.fields['rarity'] = _selectedRarity;
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['price'] = _priceController.text;
      request.fields['stock'] = _stockController.text;

      if (kIsWeb) {
        final bytes = await _pickedFile!.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: _pickedFile!.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('image', _pickedFile!.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (!mounted) return;
        _showSnackBar('Product added successfully!', Colors.green);
        Navigator.pop(context, true);
      } else {
        _showSnackBar('Server Error: ${response.body}', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ==============================================================
  // UI DI BAWAH INI 100% TETAP SEPERTI ASLINYA
  // ==============================================================

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F35).withOpacity(0.95),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFD4AF37),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Add New Product',
                      style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildSectionContainer(
                      'Weapon Image',
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E143C).withOpacity(0.6),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _pickedFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: kIsWeb
                                      ? Image.network(
                                          _pickedFile!.path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(_pickedFile!.path),
                                          fit: BoxFit.cover,
                                        ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: Color(0xFFA89EC9),
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Click to pick from gallery',
                                      style: TextStyle(
                                        color: Color(0xFFA89EC9),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionContainer(
                      'Product Information',
                      Column(
                        children: [
                          _buildTextField(
                            'Weapon Name *',
                            'e.g. Wolf\'s Gravestone',
                            _nameController,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            'Weapon Type *',
                            _selectedType,
                            ['Sword', 'Claymore', 'Polearm', 'Bow', 'Catalyst'],
                            (val) {
                              if (val != null)
                                setState(() => _selectedType = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            'Rarity *',
                            _selectedRarity,
                            ['3', '4', '5'],
                            (val) {
                              if (val != null)
                                setState(() => _selectedRarity = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            'Description *',
                            'Weapon story...',
                            _descriptionController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  'Price *',
                                  '4999',
                                  _priceController,
                                  isNumber: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  'Stock *',
                                  '5',
                                  _stockController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isValid && !_isLoading
              ? [const Color(0xFFD4AF37), const Color(0xFFB8941F)]
              : [Colors.grey, Colors.grey.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: _isValid && !_isLoading ? _addProduct : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFF1A0F35),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save to MySQL',
                style: TextStyle(
                  color: Color(0xFF1A0F35),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF5F3FF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: Color(0xFFF5F3FF)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF1E143C).withOpacity(0.6),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
              ),
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

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14),
        ),
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
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
