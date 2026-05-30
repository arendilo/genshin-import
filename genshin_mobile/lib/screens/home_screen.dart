import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:genshin_mobile/buying/checkout_screen.dart';
import 'package:genshin_mobile/buying/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Sword',
    'Claymore',
    'Polearm',
    'Bow',
    'Catalyst',
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final String baseUrl = kIsWeb
        ? 'http://localhost:3000'
        : 'http://10.0.2.2:3000';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final response = await http.get(
        Uri.parse(
          '$baseUrl/products',
        ), 
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          _products = decodedData is List
              ? decodedData
              : (decodedData['data'] ?? decodedData['weapons'] ?? []);
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal mengambil data dari server (Error ${response.statusCode})',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error connecting to server: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showProductDetails(BuildContext context, dynamic product) {
    int rarity = 5;
    if (product['rarity'] != null)
      rarity = int.tryParse(product['rarity'].toString()) ?? 5;

    int stock = 0;
    if (product['stock'] != null)
      stock = int.tryParse(product['stock'].toString()) ?? 0;
    bool isOutOfStock = stock <= 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Color(0xFF0F0820),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFD4AF37),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Weapon Details',
                    style: TextStyle(
                      color: Color(0xFFF5F3FF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E143C).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                product['image'] != null &&
                                    product['image'].toString().isNotEmpty
                                ? Image.network(
                                    product['image'],
                                    fit: BoxFit.contain,
                                  )
                                : const Icon(
                                    Icons.star,
                                    color: Colors.white24,
                                    size: 80,
                                  ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            rarity,
                            (index) => const Icon(
                              Icons.star,
                              color: Color(0xFFD4AF37),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    product['name'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 28,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildChip(product['type'] ?? 'Weapon'),
                      const SizedBox(width: 8),
                      _buildChip('$rarity-Star Weapon'),
                      if (isOutOfStock) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
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

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E143C).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product['description'] ??
                              'No description available for this weapon.',
                          style: const TextStyle(
                            color: Color(0xFFA89EC9),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: Color(0xFFA89EC9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${product['price'] ?? 0} Mora',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 20,
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
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOutOfStock ? 'Out of Stock' : '$stock Units',
                            style: TextStyle(
                              color: isOutOfStock
                                  ? Colors.redAccent
                                  : const Color(0xFFF5F3FF),
                              fontSize: 18,
                              fontWeight: isOutOfStock
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isOutOfStock
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  setState(() {
                                    int existingIndex = CartState.items
                                        .indexWhere(
                                          (item) => item.id == product['id'],
                                        );

                                    if (existingIndex != -1) {
                                      if (CartState
                                              .items[existingIndex]
                                              .quantity <
                                          stock) {
                                        CartState
                                                .items[existingIndex]
                                                .quantity +=
                                            1;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${product['name']} added to cart!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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
                                          id: product['id'] ?? 0,
                                          name: product['name'] ?? 'Unknown',
                                          type: product['type'] ?? 'Weapon',
                                          price:
                                              int.tryParse(
                                                product['price'].toString(),
                                              ) ??
                                              0,
                                          quantity: 1,
                                          maxStock: stock,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product['name']} added to cart!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  });
                                },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: isOutOfStock
                                ? Colors.white24
                                : const Color(0xFFD4AF37),
                          ),
                          label: Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: isOutOfStock
                                  ? Colors.white24
                                  : const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: isOutOfStock
                                  ? Colors.white10
                                  : const Color(0xFFD4AF37),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: isOutOfStock
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutScreen(
                                        directPurchaseItems: [
                                          CartItem(
                                            id: product['id'] ?? 0,
                                            name: product['name'] ?? 'Unknown',
                                            type: product['type'] ?? 'Weapon',
                                            price:
                                                int.tryParse(
                                                  product['price'].toString(),
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
                            backgroundColor: const Color(0xFFD4AF37),
                            disabledBackgroundColor: Colors.white10,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              color: isOutOfStock
                                  ? Colors.white38
                                  : const Color(0xFF1A0F35),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredProducts = _products.where((product) {
      bool matchesSearch = (product['name'] ?? '').toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      bool matchesCategory =
          _selectedCategory == 'All' ||
          (product['type'] ?? '') == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0820),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0F35).withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Color(0xFFF5F3FF),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Traveler',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 24,
                              fontFamily: 'Serif',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Color(0xFFF5F3FF)),
                    decoration: InputDecoration(
                      hintText: 'Search for weapons...',
                      hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFA89EC9),
                      ),
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
                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        bool isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD4AF37)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xFFD4AF37).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF1A0F35)
                                    : const Color(0xFFA89EC9),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
                  : filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        "No weapons yet.",
                        style: TextStyle(
                          color: Color(0xFFA89EC9),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildProductGridCard(product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridCard(dynamic product) {
    int rarity = 5;
    if (product['rarity'] != null)
      rarity = int.tryParse(product['rarity'].toString()) ?? 5;

    int stock = 0;
    if (product['stock'] != null)
      stock = int.tryParse(product['stock'].toString()) ?? 0;
    bool isOutOfStock = stock <= 0;

    return GestureDetector(
      onTap: () => _showProductDetails(context, product),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child:
                    product['image'] != null &&
                        product['image'].toString().isNotEmpty
                    ? Image.network(
                        product['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                          size: 40,
                        ),
                      )
                    : const Icon(Icons.star, color: Colors.white24, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                rarity,
                (index) =>
                    const Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['name'] ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              product['type'] ?? '-',
              style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 13),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${product['price'] ?? 0} Mora',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontFamily: 'Serif',
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                isOutOfStock
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                        ),
                        child: const Text(
                          'SOLD',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            int existingIndex = CartState.items.indexWhere(
                              (item) => item.id == product['id'],
                            );
                            if (existingIndex != -1) {
                              if (CartState.items[existingIndex].quantity <
                                  stock) {
                                CartState.items[existingIndex].quantity += 1;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product['name']} added to cart!',
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
                                  id: product['id'] ?? 0,
                                  name: product['name'] ?? 'Unknown',
                                  type: product['type'] ?? 'Weapon',
                                  price:
                                      int.tryParse(
                                        product['price'].toString(),
                                      ) ??
                                      0,
                                  quantity: 1,
                                  maxStock: stock,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product['name']} added to cart!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Color(0xFFD4AF37),
                            size: 16,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
