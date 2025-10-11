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

void _handleEsqueciSenha() async {
    _controller.carregando.value = true;

    String email = _controller.emailController.text.trim();
    String? erro = await _controller.esqueciasenha();

    _controller.carregando.value = false;

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link de redefinição enviado para o e-mail')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $erro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esqueci a senha')),
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
              textInputAction: TextInputAction.done, // muda o botão do teclado
              onSubmitted: (_) => _handleEsqueciSenha(),  // aqui chama o login ao pressionar "Enter"
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.carregando,
              builder: (context, carregando, _) {
                return ElevatedButton(
                  onPressed: carregando ? null : _handleEsqueciSenha,
                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enviar link de redefinição'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
