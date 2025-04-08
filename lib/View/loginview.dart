import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/logincontroller.dart';

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
      void _handleCadastro(){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aguarde')),
        );
      }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Learnix',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            ),
          backgroundColor: Color(0xFF6A5ACD),
          centerTitle: true,
          
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _controller.senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child:TextButton(
                onPressed: _handleEsqueciasenha,
                child: Text('Esqueci minha senha'),
                ),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.carregando,
              builder: (_, carregando, _) {
                return carregando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _handleLogin, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A5ACD),
                    foregroundColor: Colors.white, 
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Entrar'),
                );
              },
            ),
            SizedBox(height: 20,),
            OutlinedButton(
              onPressed: _handleCadastro, 
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

