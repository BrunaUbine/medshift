import 'package:flutter/material.dart';
import 'package:medshift/Controller/logincontroller.dart';
import 'package:medshift/View/cadastroview.dart';
import 'package:medshift/View/EsqueciASenhaView.dart';
import 'package:medshift/View/components/popup_menu.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  bool carregando = false;

  Future<void> _handleLogin() async {
    setState(() => carregando = true);

    final erro = await _controller.login(context);

    setState(() => carregando = false);

    if (!mounted) return;

    if (erro == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/inicio",
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(erro)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          'MedShift',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [buildPopupMenu(context)],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: Image.asset('assets/images/logo.png'),
            ),

            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _controller.txtEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _controller.txtSenha,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                obscureText: true,
                onSubmitted: (_) => _handleLogin(),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EsqueciSenhaView(),
                    ),
                  );
                },
                child: const Text(
                  "Esqueci minha senha",
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            carregando
                ? const CircularProgressIndicator(color: Color(0xFF1976D2))
                : ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Entrar'),
                  ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroView()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1976D2), width: 1.4),
                foregroundColor: const Color(0xFF1976D2),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
