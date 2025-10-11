import 'package:flutter/material.dart';
import 'package:medshift/Controller/cadastrocontroller.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:medshift/View/loginview.dart';

class Cadastroview extends StatefulWidget {
  const Cadastroview({super.key});

  @override
  _CadastroViewState createState() => _CadastroViewState();
}

class _CadastroViewState extends State<Cadastroview> {
  final Cadastrocontroller _controller = Cadastrocontroller();

  void _handleCadastros() async {
    _controller.carregando.value = true;

    String? erro = await _controller.cadastro();

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Aguarda 2 segundos e volta para tela de login
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro no Cadastro'),
          content: Text(erro),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }

    _controller.carregando.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),

              TextField(
                controller: _controller.nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.confirmarSenhaController,
                decoration: const InputDecoration(labelText: 'Confirmação de senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '+55 (xx) xxxxx-xxxx',
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.dtNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento',
                  hintText: 'DD/MM/AAAA',
                ),
              ),
              const SizedBox(height: 30),

              ValueListenableBuilder<bool>(
                valueListenable: _controller.carregando,
                builder: (_, carregando, __) {
                  return carregando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleCadastros,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Concluir'),
                        );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
