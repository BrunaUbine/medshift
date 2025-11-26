import 'package:flutter/material.dart';
import 'package:medshift/Controller/esqueciASenhaController.dart';
import 'package:medshift/View/components/popup_menu.dart';

class EsqueciSenhaView extends StatefulWidget {
  const EsqueciSenhaView({super.key});

  @override
  State<EsqueciSenhaView> createState() => _EsqueciSenhaViewState();
}

class _EsqueciSenhaViewState extends State<EsqueciSenhaView> {
  final EsqueciASenhaController _controller = EsqueciASenhaController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _controller.carregando.value = true;
    final erro = await _controller.esqueciasenha();
    _controller.carregando.value = false;

    if (!mounted) return;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Link de redefinição enviado para o e-mail informado."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Redefinir Senha",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const Text(
                "Digite seu e-mail cadastrado para receber um link de redefinição.",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o email";
                  if (!v.contains("@")) return "Email inválido";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ValueListenableBuilder<bool>(
                valueListenable: _controller.carregando,
                builder: (_, carregando, __) {
                  return ElevatedButton(
                    onPressed: carregando ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color(0xFF1976D2),
                    ),
                    child: carregando
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            "Enviar Link",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
