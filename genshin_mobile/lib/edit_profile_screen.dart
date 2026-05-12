import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'Traveler Knight');
  final TextEditingController _emailController = TextEditingController(text: 'traveler@teyvat.com');
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                    const Text('Edit Profile', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Avatar Edit
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
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
                              Positioned(
                                bottom: 0, right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E143C).withOpacity(0.95),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Click camera icon to change avatar', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information
                    _buildSectionContainer(
                      'Personal Information',
                      Column(
                        children: [
                          _buildTextField('Username', Icons.person, false, _usernameController),
                          const SizedBox(height: 16),
                          _buildTextField('Email', Icons.mail, false, _emailController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Change Password
                    _buildSectionContainer(
                      'Change Password',
                      Column(
                        children: [
                          _buildTextField('Current Password', Icons.lock, true, _currentPasswordController),
                          const SizedBox(height: 16),
                          _buildTextField('New Password', Icons.lock, true, _newPasswordController),
                          const SizedBox(height: 16),
                          _buildTextField('Confirm New Password', Icons.lock, true, _confirmPasswordController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                              backgroundColor: const Color(0xFF1E143C).withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, color: Color(0xFFF5F3FF)),
                                SizedBox(width: 8),
                                Text('Cancel', style: TextStyle(color: Color(0xFFF5F3FF))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, color: Color(0xFF1A0F35)),
                                  SizedBox(width: 8),
                                  Text('Save Changes', style: TextStyle(color: Color(0xFF1A0F35), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
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

  Widget _buildTextField(String label, IconData icon, bool isPassword, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Color(0xFFF5F3FF)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFA89EC9)),
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
      ],
    );
  }
}
