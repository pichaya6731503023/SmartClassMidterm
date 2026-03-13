import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using your Web Config
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA-QK2aVRtlxCz3D1eVasPoHABPVxdPe_o",
      authDomain: "smart-class-midterm.firebaseapp.com",
      projectId: "smart-class-midterm",
      storageBucket: "smart-class-midterm.firebasestorage.app",
      messagingSenderId: "538433541483",
      appId: "1:538433541483:web:791ea26318340de717a82e",
    ),
  );
  
  runApp(const SmartClassApp());
}

class SmartClassApp extends StatelessWidget {
  const SmartClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Class',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo tone for Professional Look
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        )
      ),
      home: const HomeScreen(),
    );
  }
}
