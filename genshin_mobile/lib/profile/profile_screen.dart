import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:genshin_mobile/profile/edit_profile_screen.dart';
import 'package:genshin_mobile/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = "Traveler";
  String email = "traveler@teyvat.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('username') ?? "Traveler";
      email = prefs.getString('email') ?? "traveler@teyvat.com";
    });
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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F35).withOpacity(0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                    ),
                  ),
                ),
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xFFF5F3FF),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 48,
                            backgroundColor: Color(0xFFD4AF37),
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: Color(0xFF1A0F35),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            displayName,
                            style: const TextStyle(
                              color: Color(0xFFF5F3FF),
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(color: Color(0xFFA89EC9)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      'Account Information',
                      Column(
                        children: [
                          _buildInfoRow('Username', displayName),
                          const Divider(color: Colors.white10),
                          _buildInfoRow('Email', email),
                          const Divider(color: Colors.white10),
                          _buildInfoRow('Member Since', 'May 2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContainer(
                      'Order Statistics',
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Total Orders', '12')),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard('Total Spent', '145,000'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildActionCard(
                      Icons.edit,
                      'Edit Profile',
                      'Update personal info',
                      () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        if (mounted) {
                          _loadUserData();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildActionCard(
                      Icons.logout,
                      'Logout',
                      'Sign out',
                      () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();

                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      isDestructive: true,
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
          Text(
            label,
            style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 24,
              fontFamily: 'Serif',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
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
            Icon(
              icon,
              color: isDestructive ? Colors.redAccent : const Color(0xFFD4AF37),
              size: 28,
            ),
            const SizedBox(width: 16),
            Column(
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
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFA89EC9),
                    fontSize: 12,
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
