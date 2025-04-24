class UsuarioModel {
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final DateTime dtNascimento;

  UsuarioModel({
    required this.nome,
    required this.email,
    required this.senha,
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