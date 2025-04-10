import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/logincontroller.dart';
import 'package:meuapppdv/View/cadastroview.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();

  void _handleLogin() async {
    bool success = await _controller.login();
    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou senha inválidos')),
      );
    }
  }
  void _handleEsqueciasenha() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link de recuperação enviado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learnix',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6A5ACD),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05), // espaçamento no topo

              // Logo aumentada
              SizedBox(
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),

              SizedBox(height: 40),

              // Campo de Email
              TextField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),

              SizedBox(height: 20),

              // Campo de Senha
              TextField(
                controller: _controller.senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleEsqueciasenha,
                  child: const Text('Esqueci minha senha'),
                ),
              ),

              SizedBox(height: 20),

              // Botão Entrar com loading
              ValueListenableBuilder<bool>(
                valueListenable: _controller.carregando,
                builder: (_, carregando, __) {
                  return carregando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5ACD),
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
                          child: const Text('Entrar'),
                        );
                },
              ),

              const SizedBox(height: 20),

              // Botão Cadastro
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cadastroview()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Cadastrar'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

