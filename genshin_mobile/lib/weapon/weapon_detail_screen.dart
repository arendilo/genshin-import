import 'package:flutter/material.dart';
import 'package:genshin_mobile/buying/cart_item.dart';
import 'package:genshin_mobile/buying/checkout_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class WeaponDetailScreen extends StatefulWidget {
  final int weaponId;
  const WeaponDetailScreen({Key? key, required this.weaponId})
    : super(key: key);

  @override
  State<WeaponDetailScreen> createState() => _WeaponDetailScreenState();
}

class _WeaponDetailScreenState extends State<WeaponDetailScreen> {
  Map<String, dynamic>? _weapon;
  bool _isLoading = true;
  bool _isFavorite = false; // Fitur favorite lokal (hanya UI)

  @override
  void initState() {
    super.initState();
    _fetchWeaponDetail();
  }

  // --- AMBIL DATA DARI MYSQL BERDASARKAN ID ---
  Future<void> _fetchWeaponDetail() async {
    final String baseUrl = kIsWeb
        ? 'http://127.0.0.1:3000'
        : 'http://10.0.2.2:3000';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/${widget.weaponId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _weapon = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading jika data belum selesai di-fetch
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0820),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );
    }

    // Jika id tidak ditemukan di database
    if (_weapon == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0820),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text(
            'Weapon not found!',
            style: TextStyle(color: Color(0xFFA89EC9), fontSize: 18),
          ),
        ),
      );
    }

    // Ekstrak data dengan aman
    int rarity = 5;
    if (_weapon!['rarity'] != null)
      rarity = int.tryParse(_weapon!['rarity'].toString()) ?? 5;

    int stock = 0;
    if (_weapon!['stock'] != null)
      stock = int.tryParse(_weapon!['stock'].toString()) ?? 0;
    bool isOutOfStock = stock <= 0;

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
              // --- HEADER ---
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
                      'Weapon Details',
                      style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isFavorite = !_isFavorite),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFFA89EC9),
                      ),
                    ),
                  ],
                ),
              ),

              // --- KONTEN DETAIL ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 32,
                    bottom: 40,
                  ),
                  children: [
                    // BOX GAMBAR
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                        ),
                      ),
                      child: Center(
                        child:
                            _weapon!['image'] != null &&
                                _weapon!['image'].toString().isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Image.network(
                                  _weapon!['image'],
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Icon(
                                Icons.star,
                                size: 100,
                                color: Colors.white24,
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // NAMA SENJATA
                    Text(
                      _weapon!['name'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 28,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // TIPE & RARITY CHIPS
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _weapon!['type'] ?? '-',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            rarity,
                            (index) => const Icon(
                              Icons.star,
                              color: Color(0xFFD4AF37),
                              size: 16,
                            ),
                          ),
                        ),
                        if (isOutOfStock) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.redAccent.withOpacity(0.5),
                              ),
                            ),
                            child: const Text(
                              'Sold Out',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    // DESKRIPSI
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Color(0xFFF5F3FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _weapon!['description'] ?? 'No description.',
                            style: const TextStyle(
                              color: Color(0xFFA89EC9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // HARGA & STOK
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(color: Color(0xFFA89EC9)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${int.tryParse(_weapon!['price']?.toString() ?? '0')?.toLocaleString() ?? '0'} Mora',
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 24,
                                  fontFamily: 'Serif',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isOutOfStock ? 'Status' : 'In Stock',
                                style: const TextStyle(
                                  color: Color(0xFFA89EC9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isOutOfStock ? 'Out of Stock' : '$stock units',
                                style: TextStyle(
                                  color: isOutOfStock
                                      ? Colors.redAccent
                                      : const Color(0xFFF5F3FF),
                                  fontSize: 20,
                                  fontWeight: isOutOfStock
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (TOMBOL BELI) ---
      bottomNavigationBar: _weapon == null
          ? null
          : Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0F35).withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // TOMBOL ADD TO CART
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isOutOfStock
                          ? null
                          : () {
                              setState(() {
                                int existingIndex = CartState.items.indexWhere(
                                  (item) => item.id == _weapon!['id'],
                                );
                                if (existingIndex != -1) {
                                  if (CartState.items[existingIndex].quantity <
                                      stock) {
                                    CartState.items[existingIndex].quantity +=
                                        1;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${_weapon!['name']} added!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Cannot add more. Maximum stock reached!',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                } else {
                                  CartState.items.add(
                                    CartItem(
                                      id: _weapon!['id'],
                                      name: _weapon!['name'],
                                      type: _weapon!['type'],
                                      price:
                                          int.tryParse(
                                            _weapon!['price'].toString(),
                                          ) ??
                                          0,
                                      quantity: 1,
                                      maxStock: stock,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${_weapon!['name']} added!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              });
                            },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: isOutOfStock
                            ? Colors.white24
                            : const Color(0xFFF5F3FF),
                      ),
                      label: Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: isOutOfStock
                              ? Colors.white24
                              : const Color(0xFFF5F3FF),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(
                          0xFF1E143C,
                        ).withOpacity(0.6),
                        side: BorderSide(
                          color: isOutOfStock
                              ? Colors.white10
                              : const Color(0xFFD4AF37).withOpacity(0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // TOMBOL BUY NOW
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOutOfStock
                              ? [Colors.grey.shade800, Colors.grey.shade900]
                              : [
                                  const Color(0xFFD4AF37),
                                  const Color(0xFFB8941F),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: isOutOfStock
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      directPurchaseItems: [
                                        CartItem(
                                          id: _weapon!['id'],
                                          name: _weapon!['name'],
                                          type: _weapon!['type'],
                                          price:
                                              int.tryParse(
                                                _weapon!['price'].toString(),
                                              ) ??
                                              0,
                                          quantity: 1,
                                          maxStock: stock,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: isOutOfStock
                                ? Colors.white38
                                : const Color(0xFF1A0F35),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

extension on int {
  String toLocaleString() => this.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}
