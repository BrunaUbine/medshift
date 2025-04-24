import 'package:flutter/material.dart';
import 'package:meuapppdv/View/loginview.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'MedShift',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F9FF), // azul claro sutil
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2), // azul medicina
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
      ),
    ),
    home: const LoginView(),
  );  
 }
}
