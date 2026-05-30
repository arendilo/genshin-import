import 'package:flutter/material.dart';
import 'package:genshin_mobile/buying/cart_item.dart';
import 'checkout_success_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem>? directPurchaseItems;

  const CheckoutScreen({Key? key, this.directPurchaseItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'card';
  bool _isProcessing = false;

  List<CartItem> get _items => widget.directPurchaseItems ?? CartState.items;
  int get _total =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  Future<void> _processCheckout() async {
    if (_items.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      String? storedUserId = prefs.getString('user_id');
      int userId = (storedUserId != null)
          ? (int.tryParse(storedUserId) ?? 1)
          : 1;

      final String baseUrl = kIsWeb
          ? 'http://127.0.0.1:3000'
          : 'http://10.0.2.2:3000';

      List<Map<String, dynamic>> orderData = _items.map((item) {
        return {
          'id': item.id,
          'name':
              item.name ?? 'Weapon',
          'quantity': item.quantity,
          'price': item.price,
        };
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId, 'items': orderData}),
      );

      debugPrint("Checkout Response: ${response.body}");

      if (response.statusCode == 200) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutSuccessScreen(purchasedItems: _items),
          ),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(
          errorData['message'] ?? 'Checkout failed!',
          Colors.redAccent,
        );
      }
    } catch (e) {
      _showSnackBar('Connection error! check your server.', Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFD4AF37),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Checkout',
                      style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildSectionContainer(
                      'Order Summary',
                      Column(
                        children: _items
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildOrderItem(
                                  item.name,
                                  'Qty: ${item.quantity}',
                                  item.price * item.quantity,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionContainer(
                      'Shipping Information',
                      Column(
                        children: [
                          _buildTextField('Full Name'),
                          const SizedBox(height: 12),
                          _buildTextField('Address'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('City')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField('Postal Code')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionContainer(
                      'Payment Method',
                      Column(
                        children: [
                          _buildPaymentOption(
                            'card',
                            Icons.credit_card,
                            'Credit / Debit Card',
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentOption(
                            'wallet',
                            Icons.account_balance_wallet,
                            'Digital Wallet',
                          ),
                          if (_selectedPayment == 'card') ...[
                            const SizedBox(height: 16),
                            _buildTextField('Card Number'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildTextField('MM/YY')),
                                const SizedBox(width: 12),
                                Expanded(child: _buildTextField('CVV')),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionContainer(
                      '',
                      Column(
                        children: [
                          _buildTotalRow(
                            'Subtotal',
                            '${_total.toLocaleString()} Mora',
                          ),
                          const SizedBox(height: 12),
                          _buildTotalRow('Shipping', 'Free', isHighlight: true),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Payment',
                                style: TextStyle(color: Color(0xFFF5F3FF)),
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
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isProcessing
                                      ? [Colors.grey, Colors.grey.shade700]
                                      : [
                                          const Color(0xFFD4AF37),
                                          const Color(0xFFB8941F),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (!_isProcessing)
                                    BoxShadow(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isProcessing
                                    ? null
                                    : _processCheckout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF1A0F35),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Confirm Purchase',
                                        style: TextStyle(
                                          color: Color(0xFF1A0F35),
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
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF5F3FF),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String qty, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              qty,
              style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 12),
            ),
          ],
        ),
        Text(
          price.toLocaleString(),
          style: const TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Serif'),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      style: const TextStyle(color: Color(0xFFF5F3FF)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
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
    );
  }

  Widget _buildPaymentOption(String id, IconData icon, String label) {
    final isSelected = _selectedPayment == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withOpacity(0.15)
              : const Color(0xFF1E143C).withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFA89EC9),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Color(0xFFF5F3FF))),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9))),
        Text(
          value,
          style: TextStyle(
            color: isHighlight
                ? const Color(0xFFD4AF37)
                : const Color(0xFFA89EC9),
          ),
        ),
      ],
    );
  }
}

extension on int {
  String toLocaleString() => this.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}
