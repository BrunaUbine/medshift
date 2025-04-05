class LoginModel {
  String email;
  String senha;

  LoginModel({required this.email, required this.senha});

  bool emailvalido() {
    return email.contains('@');
  }

  bool senhavalida() {
    return senha.length >= 8;
  }
}
