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
      title: 'learnix',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginView(), //  Aqui você exibe a LoginView
      debugShowCheckedModeBanner: false,
    );
  }
}
