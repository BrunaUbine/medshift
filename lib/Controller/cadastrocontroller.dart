import 'package:flutter/material.dart';
import 'package:medshift/Model/usermodel.dart';
import 'package:intl/intl.dart';

class Cadastrocontroller {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dtNascimentoController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();
  final ValueNotifier<bool> carregando = ValueNotifier(false);

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
      

    DateFormat formatoBR = DateFormat('dd/MM/yyyy');

    DateTime ? dtnascimento;
    try {
      DateTime dtnascimento = formatoBR.parseStrict(dtNascimentoStr);

    UsuarioModel user = UsuarioModel(
      nome: nome,
      email: email,
      senha: senha,
      telefone: telefone,
      dtNascimento: dtnascimento,
    );

    
    await Future.delayed(Duration(seconds: 2));

    return null; // sucesso
  } catch (_) {
    return 'Data de nascimento inválida. Use o formato dd/MM/yyyy.';
  }
}
}
