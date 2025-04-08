import 'package:flutter/material.dart';
import 'package:meuapppdv/Model/loginmodel.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final ValueNotifier<bool> carregando = ValueNotifier(false);

  Future<bool> login() async {
    carregando.value = true;
    
    String email = emailController.text;
    String senha = senhaController.text;

    LoginModel user = LoginModel(email: email, senha: senha);

    await Future.delayed(Duration(seconds: 2)); // Simula uma requisição

    carregando.value = false;

    if (user.emailvalido() && user.senhavalida()) {
      return true; // Login bem-sucedido
    }
    return false;
  }
}
