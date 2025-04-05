import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/controller.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();

  void _handleLogin() async {
    bool success = await _controller.login();
    
  }
}