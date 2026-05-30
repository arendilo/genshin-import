import 'package:flutter/material.dart';
import 'package:genshin_mobile/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GenshinApp());
}

class GenshinApp extends StatelessWidget {
  const GenshinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genshin Import',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0820),
        fontFamily: 'Serif',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
