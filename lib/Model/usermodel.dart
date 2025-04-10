class UsuarioModel {
  String nome;
  String email;
  String senha;
  String confirmarSenha;
  String telefone;
  DateTime dtNascimento;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.confirmarSenha,
    required this.telefone,
    required this.dtNascimento,
  });


  bool emailvalido() {
    return email.contains('@');
  }

  bool senhavalida() {
    return senha.length >= 8;
  }

}