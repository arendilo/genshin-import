import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                    const Text('Profile', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                        boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.15), blurRadius: 32, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 96, height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3), width: 4),
                            ),
                            child: const Center(child: Icon(Icons.person, size: 48, color: Color(0xFF1A0F35))),
                          ),
                          const SizedBox(height: 16),
                          const Text('Traveler Knight', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 24)),
                          const SizedBox(height: 8),
                          const Text('traveler@teyvat.com', style: TextStyle(color: Color(0xFFA89EC9))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Account Information
                    _buildSectionContainer(
                      'Account Information',
                      Column(
                        children: [
                          _buildInfoRow('Username', 'Traveler Knight'),
                          const Divider(color: Colors.white10, height: 24),
                          _buildInfoRow('Email', 'traveler@teyvat.com'),
                          const Divider(color: Colors.white10, height: 24),
                          _buildInfoRow('Member Since', 'May 2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Statistics
                    _buildSectionContainer(
                      'Order Statistics',
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Total Orders', '42')),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatCard('Total Spent', '189K')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Actions
                    _buildActionCard(Icons.edit, 'Edit Profile', 'Update your personal information', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                    }),
                    const SizedBox(height: 16),
                    _buildActionCard(Icons.security, 'Admin Dashboard', 'Manage weapons and inventory', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboardScreen()));
                    }),
                    const SizedBox(height: 16),
                    _buildActionCard(Icons.logout, 'Logout', 'Sign out from your account', () {
                      // Handle logout
                    }, isDestructive: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F35).withOpacity(0.95),
          border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', false, () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            }),
            _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false, () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            }),
            _buildNavItem(Icons.person, 'Profile', true, () {}),
          ],
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
          Text(title, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9))),
        Text(value, style: const TextStyle(color: Color(0xFFF5F3FF))),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 24, fontFamily: 'Serif')),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E143C).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? const Color(0xFFD4183D) : const Color(0xFFD4AF37), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
