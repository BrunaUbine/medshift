import 'package:flutter/material.dart';
import 'package:medshift/Controller/logincontroller.dart';
import 'package:medshift/View/cadastroview.dart';
import 'package:medshift/View/EsqueciASenhaView.dart';
import 'package:medshift/View/paginicialview.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  bool _carregando = false;

Future<void> _handleLogin() async {
  setState(() => _carregando = true);

  final erro = await _controller.login(context);

  setState(() => _carregando = false);

  if (erro == null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaginaInicialView()),
    );
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(erro)));
  }
}
  
  void _handleEsqueciSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EsqueciSenhaView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MedShift',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),


              SizedBox(
                height: 200,
                child: Image.asset('assets/images/logo.png'),
              ),

              const SizedBox(height: 40),


              TextField(
                controller: _controller.txtEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller.txtSenha,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  ),
                obscureText: true,
                onSubmitted: (_) => _handleLogin(),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleEsqueciSenha,
                  child: const Text('Esqueci minha senha'),
                ),
              ),

              const SizedBox(height: 20),

              _carregando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 16),
                    ),
                  ),

              const SizedBox(height: 20),

              
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Cadastroview()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1976D2)),
                  foregroundColor: const Color(0xFF1976D2),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
