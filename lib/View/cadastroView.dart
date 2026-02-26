import 'package:flutter/material.dart';
import 'package:medshift/Controller/cadastrocontroller.dart';
import 'package:medshift/View/loginview.dart';
import 'package:medshift/View/components/popup_menu.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final Cadastrocontroller _controller = Cadastrocontroller();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    _controller.carregando.value = true;
    final erro = await _controller.cadastro();
    _controller.carregando.value = false;

    if (!mounted) return;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro no Cadastro"),
          content: Text(erro),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "Cadastro",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Criar Conta",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),

                  const SizedBox(height: 22),

                  _campo(
                    label: "Nome completo",
                    controller: _controller.nomeController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o nome" : null,
                  ),

                  const SizedBox(height: 16),

                  _campo(
                    label: "Email",
                    controller: _controller.emailController,
                    keyboard: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Informe o email";
                      if (!v.contains("@")) return "Email inválido";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _campo(
                    label: "Senha",
                    controller: _controller.senhaController,
                    obscure: true,
                    validator: (v) =>
                        v != null && v.length >= 8
                            ? null
                            : "A senha deve ter ao menos 8 caracteres",
                  ),

                  const SizedBox(height: 16),

                  _campo(
                    label: "Confirmar senha",
                    controller: _controller.confirmarSenhaController,
                    obscure: true,
                    validator: (v) =>
                        v == _controller.senhaController.text
                            ? null
                            : "As senhas não conferem",
                  ),

                  const SizedBox(height: 16),

                  _campo(
                    label: "Telefone",
                    controller: _controller.telefoneController,
                    hint: "(11)91234-5678",
                    keyboard: TextInputType.number,
                    onChanged: _controller.formatarTelefone,
                    validator: (v) =>
                        v != null && v.length >= 14
                            ? null
                            : "Telefone inválido",
                  ),

                  const SizedBox(height: 16),

                  _campo(
                    label: "Data de nascimento",
                    hint: "DD/MM/AAAA",
                    controller: _controller.dtNascimentoController,
                    keyboard: TextInputType.number,
                    onChanged: _controller.formatarData,
                    validator: (v) =>
                        v != null && v.length == 10
                            ? null
                            : "Data inválida",
                  ),

                  const SizedBox(height: 30),

                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.carregando,
                    builder: (_, carregando, __) {
                      return carregando
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1976D2),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _handleCadastro,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                "Concluir Cadastro",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required String label,
    TextEditingController? controller,
    TextInputType keyboard = TextInputType.text,
    String? hint,
    bool obscure = false,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}
