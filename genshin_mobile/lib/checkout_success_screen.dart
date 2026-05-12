import 'package:flutter/material.dart';
import 'home_screen.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({Key? key}) : super(key: key);

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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Success Icon Placeholder
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 80, height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0x80D4AF37), blurRadius: 30)],
                      ),
                      child: const Center(child: Icon(Icons.check_circle, color: Color(0xFF1A0F35), size: 48)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                const Text('Purchase Successful!', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 28, fontFamily: 'Serif')),
                const SizedBox(height: 12),
                const Text('Thank you for your order, Traveler', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Your weapons are on their way from Teyvat', style: TextStyle(color: Color(0xFF6B5BB5), fontSize: 14)),
                const SizedBox(height: 32),

                // Order Info Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E143C).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.inventory_2, color: Color(0xFFD4AF37)),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Order ID', style: TextStyle(color: Color(0xFFF5F3FF))),
                              SizedBox(height: 4),
                              Text('#GI-2026-05-12-7834', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),
                      const Text('Order Summary', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 16)),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Primordial Jade Cutter', 'Qty: 1', '4,999'),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Staff of Homa', 'Qty: 2', '11,998'),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Total Paid', style: TextStyle(color: Color(0xFFF5F3FF))),
                          Text('16,997 Mora', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontFamily: 'Serif')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Back to Home Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home, color: Color(0xFF1A0F35)),
                      label: const Text('Back to Home', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String name, String qty, String price) {
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
}
