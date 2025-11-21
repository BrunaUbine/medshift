import 'package:flutter/material.dart';
import 'package:medshift/Controller/esqueciASenhaController.dart';
import 'package:medshift/View/loginview.dart';

class EsqueciSenhaView extends StatefulWidget {
  const EsqueciSenhaView({super.key});

  @override
  _EsqueciasenhaViewState createState() => _EsqueciasenhaViewState();
}

class _EsqueciasenhaViewState extends State<EsqueciSenhaView> {
  final EsqueciASenhaController _controller = EsqueciASenhaController();

  Future<void> _handleEsqueciSenha() async {
    final erro = await _controller.esqueciasenha();

    if (!mounted) return;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link de redefinição enviado para o e-mail.'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
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
        title: const Text('Esqueci a Senha'),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informe o e-mail cadastrado',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleEsqueciSenha(),
            ),

            const SizedBox(height: 20),

            ValueListenableBuilder<bool>(
              valueListenable: _controller.carregando,
              builder: (_, carregando, __) {
                return ElevatedButton(
                  onPressed: carregando ? null : _handleEsqueciSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          'Enviar link de redefinição',
                          style: TextStyle(fontSize: 16),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
