import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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

      Navigator.pushReplacement(
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
      appBar: AppBar(
        title: const Text("Cadastro", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [buildPopupMenu(context)],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 20),

              TextFormField(
                controller: _controller.nomeController,
                decoration: const InputDecoration(labelText: "Nome completo"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nome" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o email";
                  if (!v.contains("@")) return "Email inválido";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _controller.senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
                validator: (v) =>
                    v != null && v.length >= 8
                        ? null
                        : "A senha deve ter ao menos 8 caracteres",
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _controller.confirmarSenhaController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirmar senha"),
                validator: (v) =>
                    v == _controller.senhaController.text
                        ? null
                        : "As senhas não conferem",
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _controller.telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  hintText: "+55 (00) 00000-0000",
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _controller.dtNascimentoController,
                decoration: const InputDecoration(
                  labelText: "Data de nascimento",
                  hintText: "DD/MM/AAAA",
                ),
                keyboardType: TextInputType.number,
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
    );
  }
}
