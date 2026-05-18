import 'package:flutter/material.dart';
import 'package:genshin_mobile/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_add_product_screen.dart';
import 'admin_edit_product_screen.dart';

class AdminWeapon {
  final int id;
  final String name;
  final String type;
  final int price;
  final int stock;
  final int rarity;
  final String? image;

  AdminWeapon({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.stock,
    required this.rarity,
    this.image,
  });

  factory AdminWeapon.fromJson(Map<String, dynamic> json) {
    return AdminWeapon(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? 'Sword',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      rarity: json['rarity'] ?? 5,
      image: json['image'],
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _searchQuery = '';
  List<AdminWeapon> _allWeapons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeapons();
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _fetchWeapons() async {
    final String baseUrl = kIsWeb
        ? 'http://127.0.0.1:3000'
        : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allWeapons = data.map((json) => AdminWeapon.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Error loading data: $e', Colors.redAccent);
      setState(() => _isLoading = false);
    }
  }

  // ==============================================================
  // BAGIAN YANG DI-UPDATE (NYELIPIN TOKEN JWT)
  // ==============================================================
  Future<void> _deleteWeapon(int id) async {
    final String baseUrl = kIsWeb
        ? 'http://127.0.0.1:3000'
        : 'http://10.0.2.2:3000';

    try {
      // 1. Ambil Token dari memori HP
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      // 2. Kirim request dengan Header Authorization (Syarat Dosen)
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: {
          'Authorization':
              'Bearer $token', // Membawa token biar dibolehin hapus
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('Weapon deleted successfully!', Colors.green);
        _fetchWeapons();
      } else {
        _showSnackBar(
          'Failed: ${jsonDecode(response.body)['message']}',
          Colors.redAccent,
        );
      }
    } catch (e) {
      _showSnackBar('Failed to delete: $e', Colors.redAccent);
    }
  }

  // ==============================================================
  // UI DI BAWAH TETAP ORIGINAL PUNYA KAMU
  // ==============================================================

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    List<AdminWeapon> filteredWeapons = _allWeapons
        .where((w) => w.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
              _buildHeader(),
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
                          _buildTitleRow(filteredWeapons.length),
                          const SizedBox(height: 24),
                          if (filteredWeapons.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text(
                                  'No weapons found.',
                                  style: TextStyle(color: Color(0xFFA89EC9)),
                                ),
                              ),
                            ),
                          ...filteredWeapons
                              .map((weapon) => _buildWeaponCard(weapon))
                              .toList(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F35).withOpacity(0.95),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _handleLogout,
                child: const Icon(Icons.logout, color: Color(0xFFD4AF37)),
              ),
              const Text(
                'Admin Dashboard',
                style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(color: Color(0xFFF5F3FF)),
            decoration: InputDecoration(
              hintText: 'Search weapons...',
              hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFA89EC9)),
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
      ),
    );
  }

  Widget _buildTitleRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weapon Management',
              style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 18),
            ),
            Text(
              '$count items in database',
              style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 13),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminAddProductScreen(),
              ),
            );
            if (result == true) _fetchWeapons();
          },
          icon: const Icon(Icons.add, color: Color(0xFF1A0F35)),
          label: const Text(
            'Add New',
            style: TextStyle(
              color: Color(0xFF1A0F35),
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeaponCard(AdminWeapon weapon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0820),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: weapon.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          weapon.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                          ),
                        ),
                      )
                    : const Icon(Icons.image, color: Colors.white10),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weapon.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        weapon.rarity,
                        (i) => const Icon(
                          Icons.star,
                          color: Color(0xFFD4AF37),
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminEditProductScreen(productId: weapon.id),
                        ),
                      );
                      if (result == true) _fetchWeapons();
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteWeapon(weapon.id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoMini('Type', weapon.type),
              _buildInfoMini('Price', '${weapon.price} Mora'),
              _buildInfoMini('Stock', '${weapon.stock} Pcs'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoMini(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        Text(val, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}
