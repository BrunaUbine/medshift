import 'package:flutter/material.dart';

class EsqueciASenhaController {
  final TextEditingController emailController = TextEditingController();
  final carregando = ValueNotifier<bool>(false);

  Future<String?> esqueciasenha() async {
    String email = emailController.text;
    if (email.isEmpty || !email.contains('@')) return 'Email inválido.';
    try {
      await Future.delayed(Duration(seconds: 2));
      // se sucesso:
      return null; 
    } catch (e) {
      return e.toString();
    } finally {
      carregando.value = false;
    }
  }
}
