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


  void formatarData(String value) {
    String nums = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (nums.length > 8) nums = nums.substring(0, 8);

    String formatada = "";
    if (nums.length >= 3 && nums.length <= 4) {
      formatada = "${nums.substring(0, 2)}/${nums.substring(2)}";
    } else if (nums.length >= 5) {
      formatada =
          "${nums.substring(0, 2)}/${nums.substring(2, 4)}/${nums.substring(4)}";
    } else {
      formatada = nums;
    }

    dtNascimentoController.value = TextEditingValue(
      text: formatada,
      selection: TextSelection.collapsed(offset: formatada.length),
    );
  }


  void formatarTelefone(String value) {
    String nums = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (nums.length > 11) nums = nums.substring(0, 11);

    String formatado = "";
    if (nums.length >= 1) {
      formatado = "(${nums.substring(0, nums.length.clamp(0, 2))}";
    }
    if (nums.length >= 3) {
      formatado += ")${nums.substring(2, nums.length.clamp(2, 7))}";
    }
    if (nums.length >= 8) {
      formatado += "-${nums.substring(7)}";
    }

    telefoneController.value = TextEditingValue(
      text: formatado,
      selection: TextSelection.collapsed(offset: formatado.length),
    );
  }

  Future<String?> cadastro() async {
    carregando.value = true;

    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();
    String confirmarSenha = confirmarSenhaController.text.trim();
    String telefone = telefoneController.text.trim();
    String dtNascimentoStr = dtNascimentoController.text.trim();

    if (nome.isEmpty) {
      carregando.value = false;
      return 'Nome é obrigatório.';
    }

    if (email.isEmpty || !email.contains('@')) {
      carregando.value = false;
      return 'Email inválido.';
    }

    if (senha.length < 8) {
      carregando.value = false;
      return 'A senha deve ter ao menos 8 caracteres.';
    }

    if (confirmarSenha != senha) {
      carregando.value = false;
      return 'As senhas deverão ser iguais.';
    }

    if (telefone.isEmpty || telefone.length < 14) {
      carregando.value = false;
      return 'Telefone inválido.';
    }

    DateTime? dtNascimento;
    try {
      dtNascimento = DateFormat('dd/MM/yyyy').parseStrict(dtNascimentoStr);
    } catch (e) {
      carregando.value = false;
      return 'Data de nascimento inválida. Use o formato dd/MM/yyyy.';
    }

    try {
      final credencial = await auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

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
