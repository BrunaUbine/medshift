class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Informe o e-mail";
    }
    if (!value.contains('@') || !value.contains('.')) {
      return "E-mail inválido";
    }
    return null;
  }

  static String? senha(String? value) {
    if (value == null || value.length < 6) {
      return "A senha deve ter pelo menos 6 caracteres";
    }
    return null;
  }

  static String? texto(String? value, {String campo = "Campo"}) {
    if (value == null || value.trim().isEmpty) {
      return "$campo é obrigatório";
    }
    return null;
  }

  static String? telefone(String? value) {
    if (value == null || value.trim().length < 10) {
      return "Telefone inválido";
    }
    return null;
  }

  static String? confirmarSenha(String? senha, String? confirmacao) {
    if (senha != confirmacao) {
      return "As senhas não coincidem";
    }
    return null;
  }
}
