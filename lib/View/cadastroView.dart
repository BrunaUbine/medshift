import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/cadastrocontroller.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';


class Cadastroview extends StatefulWidget {
  const Cadastroview({super.key});
  @override
  _CadastroViewState createState() => _CadastroViewState();
}

class _CadastroViewState extends State<Cadastroview> {
  final Cadastrocontroller _controller = Cadastrocontroller();

void _handleCadastros() async {
  _controller.carregando.value = true; // Ativa o loading

  String? erro = await _controller.cadastro();

  if (erro == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cadastro realizado com sucesso')),
    );
  } else {
    await Future.delayed(Duration(milliseconds: 500));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Erro no Cadastro'),
        content: Text(erro),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
    _controller.carregando.value = false;
  }
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
              SizedBox(height: screenHeight * 0.05), // espaçamento no topo

              // Campo de Nome
              TextField(
                controller: _controller.nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),

              SizedBox(height: 20),

              // Campo de Email
              TextField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),

              SizedBox(height: 20),

              //Campo de Senha
              TextField(
                controller: _controller.senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),

              SizedBox(height: 20),
              //Campo de Confirmação de Senha

              TextField(
                controller: _controller.confirmarSenhaController,
                decoration: const InputDecoration(labelText: 'Confirmação de senha'),
                obscureText: true,
              ),
              
              SizedBox(height: 20),              

              //Campo de telefone
              TextField(
                controller: _controller.telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '+55 (xx) xxxxx-xxxx'),
              ),

              SizedBox(height: 20),

              //Campo de Data de Nascimento
              TextField(
                controller: _controller.dtNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento',
                  hintText: 'DD/MM/AAAA',
                  ),  
              ),


              // Botão Entrar com loading
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

