import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends ChangeNotifier {
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool carregando = false;
  void setLoading(bool v) {
    carregando = v;
    notifyListeners();
  }

  Future<String?> login(BuildContext context) async {
    try {
      setLoading(true);

      final email = txtEmail.text.trim();
      final senha = txtSenha.text.trim();

      if (email.isEmpty || senha.isEmpty) {
        setLoading(false);
        return "Preencha todos os campos.";
      }

      await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      setLoading(false);
      return null; 

    } on FirebaseAuthException catch (e) {
      setLoading(false);

      switch (e.code) {
        case 'user-not-found':
          return "Usuário não encontrado.";
        case 'wrong-password':
          return "Senha incorreta.";
        case 'invalid-email':
          return "Email inválido.";
        default:
          return e.message ?? "Erro desconhecido.";
      }
    } catch (e) {
      setLoading(false);
      return "Erro inesperado: $e";
    }
  }

  void limpar() {
    txtEmail.clear();
    txtSenha.clear();
  }
}
