

class LoginModel {
  String email;
  String senha;

  LoginModel({required this.email, required this.senha});

  bool emailValido () {
    return email.contains('@');
  }

  bool senhaValida () {
    return senha.length >= 6;
  }

}