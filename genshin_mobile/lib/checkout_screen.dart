import 'package:flutter/material.dart';
import 'checkout_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'card';
  
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
                    const Text('Checkout', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Order Summary
                    _buildSectionContainer(
                      'Order Summary',
                      Column(
                        children: [
                          _buildOrderItem('Primordial Jade Cutter', 'Qty: 1', '4,999'),
                          const SizedBox(height: 12),
                          _buildOrderItem('Staff of Homa', 'Qty: 2', '11,998'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Shipping Information
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

                    // Payment Method
                    _buildSectionContainer(
                      'Payment Method',
                      Column(
                        children: [
                          _buildPaymentOption('card', Icons.credit_card, 'Credit / Debit Card'),
                          const SizedBox(height: 12),
                          _buildPaymentOption('wallet', Icons.account_balance_wallet, 'Digital Wallet'),
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

                    // Promo Code
                    _buildSectionContainer(
                      'Promo Code',
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Color(0xFFF5F3FF)),
                              decoration: InputDecoration(
                                hintText: 'Enter code',
                                hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                                prefixIcon: const Icon(Icons.local_offer, color: Color(0xFFA89EC9)),
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
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E143C).withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                              ),
                            ),
                            child: const Text('Apply', style: TextStyle(color: Color(0xFFD4AF37))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Totals
                    _buildSectionContainer(
                      '',
                      Column(
                        children: [
                          _buildTotalRow('Subtotal', '16,997 Mora'),
                          const SizedBox(height: 12),
                          _buildTotalRow('Shipping', 'Free', isHighlight: true),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Total Payment', style: TextStyle(color: Color(0xFFF5F3FF))),
                              Text('16,997 Mora', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 24, fontFamily: 'Serif')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CheckoutSuccessScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Confirm Purchase', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
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
            Text(title, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String qty, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 14)),
            const SizedBox(height: 4),
            Text(qty, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 12)),
          ],
        ),
        Text(price, style: const TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Serif')),
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
          borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
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
          color: isSelected ? const Color(0xFFD4AF37).withOpacity(0.15) : const Color(0xFF1E143C).withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9), size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Color(0xFFF5F3FF))),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9))),
        Text(value, style: TextStyle(color: isHighlight ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9))),
      ],
    );
  }
}
