import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart'; // Import untuk ambil token

class AdminEditProductScreen extends StatefulWidget {
  final int productId;

  const AdminEditProductScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String _selectedType = 'Sword';
  String _selectedRarity = '5';

  String? _existingImageUrl;
  XFile? _pickedFile;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    final String baseUrl = kIsWeb
        ? 'http://127.0.0.1:3000'
        : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _nameController.text = data['name'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _priceController.text = (data['price'] ?? 0).toString();
          _stockController.text = (data['stock'] ?? 0).toString();
          _selectedType = data['type'] ?? 'Sword';
          _selectedRarity = (data['rarity'] ?? 5).toString();
          _existingImageUrl = data['image'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error loading product: $e', Colors.redAccent);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _pickedFile = image);
  }

  // ==============================================================
  // LOGIKA SAVE (PUT) DENGAN TOKEN JWT
  // ==============================================================
  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      _showSnackBar('Please fill all required fields!', Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Ambil Token dari HP
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final String baseUrl = kIsWeb
          ? 'http://127.0.0.1:3000'
          : 'http://10.0.2.2:3000';

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/products/${widget.productId}'),
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

      if (_pickedFile != null) {
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
      }

      var streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        if (!mounted) return;
        _showSnackBar('Product updated successfully!', Colors.green);
        Navigator.pop(context, true);
      } else {
        _showSnackBar('Failed to update product', Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar('Failed to connect: $e', Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ==============================================================
  // LOGIKA DELETE DENGAN TOKEN JWT
  // ==============================================================
  Future<void> _deleteProduct() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final String baseUrl = kIsWeb
          ? 'http://127.0.0.1:3000'
          : 'http://10.0.2.2:3000';

      final response = await http.delete(
        Uri.parse('$baseUrl/products/${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token', // Membawa token biar sah
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        _showSnackBar('Product deleted!', Colors.green);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Failed to delete product: $e', Colors.redAccent);
    }
  }

  // ==============================================================
  // UI DI BAWAH INI 100% TETAP SEPERTI ASLINYA
  // ==============================================================

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E143C),
        title: const Text(
          'Delete Weapon',
          style: TextStyle(color: Color(0xFFD4183D)),
        ),
        content: const Text(
          'Are you sure you want to delete this weapon?',
          style: TextStyle(color: Color(0xFFF5F3FF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFA89EC9)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProduct();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFD4183D)),
            ),
          ),
        ],
      ),
    );
  }

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
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const Text(
                      'Edit Product',
                      style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: _handleDelete,
                      child: const Icon(Icons.delete, color: Color(0xFFD4183D)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD4AF37),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          _buildSectionContainer(
                            'Weapon Image',
                            Row(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1E143C,
                                    ).withOpacity(0.6),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withOpacity(0.3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: _pickedFile != null
                                        ? (kIsWeb
                                              ? Image.network(
                                                  _pickedFile!.path,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(_pickedFile!.path),
                                                  fit: BoxFit.cover,
                                                ))
                                        : (_existingImageUrl != null &&
                                                  _existingImageUrl!.isNotEmpty
                                              ? Image.network(
                                                  _existingImageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (c, e, s) =>
                                                      const Icon(
                                                        Icons.broken_image,
                                                        color: Colors.white24,
                                                      ),
                                                )
                                              : const Center(
                                                  child: Text(
                                                    '🗡️',
                                                    style: TextStyle(
                                                      fontSize: 48,
                                                    ),
                                                  ),
                                                )),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(
                                      Icons.upload_file,
                                      color: Color(0xFFD4AF37),
                                    ),
                                    label: const Text(
                                      'Change Image',
                                      style: TextStyle(
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      side: BorderSide(
                                        color: const Color(
                                          0xFFD4AF37,
                                        ).withOpacity(0.2),
                                      ),
                                      backgroundColor: const Color(
                                        0xFF1E143C,
                                      ).withOpacity(0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionContainer(
                            'Product Information',
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField('Weapon Name', _nameController),
                                const SizedBox(height: 16),
                                _buildDropdown(
                                  'Weapon Type',
                                  _selectedType,
                                  [
                                    'Sword',
                                    'Claymore',
                                    'Polearm',
                                    'Bow',
                                    'Catalyst',
                                  ],
                                  (val) {
                                    if (val != null)
                                      setState(() => _selectedType = val);
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildDropdown(
                                  'Rarity',
                                  _selectedRarity,
                                  ['3', '4', '5'],
                                  (val) {
                                    if (val != null)
                                      setState(() => _selectedRarity = val);
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  'Description',
                                  _descriptionController,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        'Price (Mora)',
                                        _priceController,
                                        isNumber: true,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTextField(
                                        'Stock',
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _isSaving ? null : _handleSave,
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF1A0F35),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.save,
                                      color: Color(0xFF1A0F35),
                                    ),
                              label: Text(
                                _isSaving ? 'Saving...' : 'Save Changes',
                                style: const TextStyle(
                                  color: Color(0xFF1A0F35),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
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
          style: const TextStyle(color: Color(0xFFF5F3FF)),
          decoration: InputDecoration(
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
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
