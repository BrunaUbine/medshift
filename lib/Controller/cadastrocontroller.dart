import 'package:flutter/material.dart';
import 'package:medshift/Model/usermodel.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastrocontroller {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dtNascimentoController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();
  final ValueNotifier<bool> carregando = ValueNotifier(false);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> cadastro() async {
    carregando.value = true;
    
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;
    String telefone = telefoneController.text;
    String dtNascimentoStr = dtNascimentoController.text;

    
    if (nome.isEmpty) return 'Nome é obrigatório.';
    if (email.isEmpty || !email.contains('@')) return 'Email inválido.';
    if (senha.length < 8) return 'A senha deve ter ao menos 8 caracteres.';
    if (confirmarSenha != senha) return 'As senhas deverão ser iguais';
    if (telefone.isEmpty || telefone.length < 8) return 'Telefone inválido.';
      

    DateTime? dtNascimento;
    try {
      dtNascimento = DateFormat('dd/MM/yyyy').parseStrict(dtNascimentoStr);
    } catch (e) {
      return 'Data de nascimento inválida. Use o formato dd/MM/yyyy.';
    }

    try {
      final credencial = await auth.createUserWithEmailAndPassword(email: email, password: senha);
      final uid = credencial.user!.uid;

      UsuarioModel usuario = UsuarioModel(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
        dtNascimento: dtNascimento,
    );
     await db.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nome': usuario.nome,
        'email': usuario.email,
        'telefone': usuario.telefone,
        'dtNascimento': usuario.dtNascimento.toIso8601String(),
        'nomeLower': usuario.nome.toLowerCase(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      carregando.value = false;
      return null;


    } on FirebaseAuthException catch (e) {
      carregando.value = false;

      switch (e.code) {
          case 'email-already-in-use':
            return 'Este e-mail já está em uso.';
          case 'invalid-email':
            return 'Formato de e-mail inválido.';
          case 'weak-password':
            return 'Senha muito fraca.';
          default:
            return 'Erro ao criar conta: ${e.message}';
      }
    } catch (e) {
      carregando.value = false;
      return 'Erro inesperado: $e';
    }
  }
}
    
