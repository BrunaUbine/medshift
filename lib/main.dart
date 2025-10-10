import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meuapppdv/View/loginview.dart';
import 'package:meuapppdv/Controller/paginicialcontroller.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PagInicialController()),
      ],
      child: MaterialApp(
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
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
        ),
          labelStyle: const TextStyle(color: Color(0xFF1976D2)),
        ),
      ),
      home: const LoginView(),
    ),
  );  
 }
}
