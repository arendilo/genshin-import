import 'package:flutter/material.dart';

class CartItem {
  final int id;
  final String name;
  final String type;
  final int price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [
    CartItem(id: 1, name: "Primordial Jade Cutter", type: "Sword", price: 4999, image: "assets/images/jade-cutter.png", quantity: 1),
    CartItem(id: 2, name: "Staff of Homa", type: "Polearm", price: 5999, image: "assets/images/homa.png", quantity: 2),
  ];

  void _updateQuantity(int id, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        int newQuantity = _cartItems[index].quantity + delta;
        if (newQuantity < 1) newQuantity = 1;
        _cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _removeItem(int id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
  }

  int get _total => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

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
                    const Text('Shopping Cart', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    const SizedBox(width: 24), // Balance
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shopping_cart, size: 80, color: Color(0xFF6B5BB5)),
                            SizedBox(height: 16),
                            Text('Your cart is empty', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 18)),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          // Items
                          ..._cartItems.map((item) => _buildCartItem(item)).toList(),

                          const SizedBox(height: 24),

                          // Summary
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E143C).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal', style: TextStyle(color: Color(0xFFA89EC9))),
                                    Text('${_total} Mora', style: const TextStyle(color: Color(0xFFA89EC9))),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Shipping', style: TextStyle(color: Color(0xFFA89EC9))),
                                    Text('Free', style: TextStyle(color: Color(0xFFD4AF37))),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(color: Color(0xFFD4AF37), thickness: 0.2),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total', style: TextStyle(color: Color(0xFFF5F3FF))),
                                    Text(
                                      '${_total} Mora',
                                      style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 24, fontFamily: 'Serif'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('Proceed to Checkout', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
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
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.1), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E143C).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                ),
                child: const Center(child: Icon(Icons.star, color: Colors.white24, size: 40)), // Placeholder for image
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(item.type, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                    const SizedBox(height: 8),
                    Text('${item.price} Mora', style: const TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Serif')),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _removeItem(item.id),
                child: const Icon(Icons.delete_outline, color: Color(0xFFA89EC9)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Quantity:', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
              const SizedBox(width: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _updateQuantity(item.id, -1),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: const Color(0xFF1E143C).withOpacity(0.6), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                      child: const Center(child: Icon(Icons.remove, color: Color(0xFFD4AF37), size: 16)),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: Center(child: Text('${item.quantity}', style: const TextStyle(color: Color(0xFFF5F3FF)))),
                  ),
                  GestureDetector(
                    onTap: () => _updateQuantity(item.id, 1),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: const Color(0xFF1E143C).withOpacity(0.6), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                      child: const Center(child: Icon(Icons.add, color: Color(0xFFD4AF37), size: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
