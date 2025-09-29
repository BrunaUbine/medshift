import 'package:flutter/material.dart';

class EsqueciASenhaController {
  final TextEditingController emailController = TextEditingController();
  final carregando = ValueNotifier<bool>(false);

  Future<String?> esqueciasenha() async {
    try {
      // Simulação do envio do link
      await Future.delayed(Duration(seconds: 2));
      // se sucesso:
      return null; // sem erro
    } catch (e) {
      return e.toString();
    } finally {
      carregando.value = false;
    }
  }
}