import 'package:flutter/material.dart';
import 'package:genshin_mobile/buying/cart_item.dart';
import 'package:genshin_mobile/buying/checkout_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> get _cartItems => CartState.items;

  String _formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (kIsWeb) return url; 

    return url
        .replaceAll('localhost', '10.0.2.2')
        .replaceAll('127.0.0.1', '10.0.2.2');
  }

  void _updateQuantity(int id, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        int newQuantity = _cartItems[index].quantity + delta;
        if (newQuantity < 1) newQuantity = 1;
        if (newQuantity > _cartItems[index].maxStock) {
          newQuantity = _cartItems[index].maxStock;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum stock reached!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        _cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _removeItem(int id) {
    setState(() => _cartItems.removeWhere((item) => item.id == id));
  }

  int get _total =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

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
              _buildHeader(),
              Expanded(
                child: _cartItems.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          ..._cartItems
                              .map((item) => _buildCartItem(item))
                              .toList(),
                          const SizedBox(height: 24),
                          _buildSummaryCard(),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0F35).withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        ),
      ),
      child: const Text(
        'Shopping Cart',
        style: TextStyle(
          color: Color(0xFFF5F3FF),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.remove_shopping_cart, size: 80, color: Color(0xFF6B5BB5)),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(color: Color(0xFFA89EC9), fontSize: 18),
          ),
        ],
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
                  color: const Color(0xFF0F0820),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (item.image != null && item.image!.isNotEmpty)
                      ? Image.network(
                          _formatImageUrl(item.image), 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.white24,
                                size: 30,
                              ),
                        )
                      : const Icon(Icons.star, color: Colors.white24, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Color(0xFFF5F3FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.type,
                      style: const TextStyle(
                        color: Color(0xFFA89EC9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price.toLocaleString()} Mora',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _removeItem(item.id),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFA89EC9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock: ${item.maxStock}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
              Row(
                children: [
                  const Text(
                    'Qty:',
                    style: TextStyle(color: Color(0xFFA89EC9), fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  _buildQtyBtn(
                    Icons.remove,
                    () => _updateQuantity(item.id, -1),
                  ),
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(color: Color(0xFFF5F3FF)),
                      ),
                    ),
                  ),
                  _buildQtyBtn(Icons.add, () => _updateQuantity(item.id, 1)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E143C),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
        ),
        child: Icon(icon, color: const Color(0xFFD4AF37), size: 14),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '${_total.toLocaleString()} Mora'),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping', 'Free', isGold: true),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFD4AF37), thickness: 0.2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 16),
              ),
              Text(
                '${_total.toLocaleString()} Mora',
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 24,
                  fontFamily: 'Serif',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCheckoutBtn(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9))),
        Text(
          val,
          style: TextStyle(
            color: isGold ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBtn() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Proceed to Checkout',
            style: TextStyle(
              color: Color(0xFF1A0F35),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
