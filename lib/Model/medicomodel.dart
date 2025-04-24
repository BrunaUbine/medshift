import 'package:meuapppdv/Model/usermodel.dart';

class Medicomodel extends UsuarioModel {
  final String crm;
  final String especialidade;


  Medicomodel({
    
    required String nome,
    required String email,
    required String senha,
    required DateTime dtNascimento,
    required String telefone,
    required this.crm,
    required this.especialidade,
  }) :super(
    nome: nome,
    email: email,
    senha: senha,
    dtNascimento: dtNascimento,
    telefone: telefone,
  );


  bool crmvalido() {
    return crm.length == 6;
  }

}