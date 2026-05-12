import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        fontFamily: 'Serif', // Use a custom font if available
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
