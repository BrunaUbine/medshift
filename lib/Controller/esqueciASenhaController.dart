import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueciASenhaController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final carregando = ValueNotifier<bool>(false);

  Future<String?> esqueciasenha() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) return 'Email inválido.';
    try {
      carregando.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      carregando.value = false;
      return null; 
    } on FirebaseAuthException catch (e) {
      carregando.value = false;
      switch (e.code) {
        case 'invalid-email':
          return 'Formato de e-mail inválido.';
        case 'user-not-found':
          return 'Nenhum usuário encontrado com este e-mail.';
        default:
          return 'Erro: ${e.message}';
      }
    } catch (e) {
      carregando.value = false;
      return 'Erro inesperado: $e';
    }
  }
}