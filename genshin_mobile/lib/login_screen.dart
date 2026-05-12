import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      // Untuk Web wajib menggunakan signInWithPopup.
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(googleProvider);
      }
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0820),
              Color(0xFF1A0F35),
              Color(0xFF2A1F4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Genshin Import',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 28,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome back, Traveler',
                    style: TextStyle(color: Color(0xFFA89EC9), fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Glassmorphism Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E143C).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email', style: TextStyle(color: Color(0xFFF5F3FF))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Color(0xFFF5F3FF)),
                          decoration: InputDecoration(
                            hintText: 'traveler@teyvat.com',
                            hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                            prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFFA89EC9)),
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
                        const SizedBox(height: 16),

                        const Text('Password', style: TextStyle(color: Color(0xFFF5F3FF))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Color(0xFFF5F3FF)),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFA89EC9)),
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
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Google Sign In
                        Row(
                          children: [
                            Expanded(child: Divider(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('or', style: TextStyle(color: Color(0xFFA89EC9))),
                            ),
                            Expanded(child: Divider(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                          ],
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _signInWithGoogle,
                            icon: _isLoading 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.g_mobiledata, size: 32, color: Colors.white),
                            label: const Text('Continue with Google', style: TextStyle(color: Color(0xFFF5F3FF))),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                              backgroundColor: const Color(0xFF1E143C).withOpacity(0.6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
