import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PagInicialController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> funcionalidadeNames = [
    "Pacientes",
    "Agenda",
    "Anotações",
    "Chat",
    "Sobre",
    "Sair",
  ];

  final Map<String, IconData> funcionalidadeIcons = {
    "Pacientes": Icons.people_alt,
    "Agenda": Icons.calendar_month,
    "Anotações": Icons.edit_note,
    "Chat": Icons.chat_bubble_outline,
    "Sobre": Icons.info_outline,
    "Sair": Icons.logout,
  };

  List<String> get funcionalidades => funcionalidadeNames;

  IconData getIconFor(String f) =>
      funcionalidadeIcons[f] ?? Icons.help_outline;

  void aoClicar(BuildContext context, String funcionalidade) async {
    switch (funcionalidade) {
      case "Pacientes":
        Navigator.pushNamed(context, "/pacientes");
        break;

      case "Agenda":
        Navigator.pushNamed(context, "/agenda");
        break;

      case "Anotações":
        Navigator.pushNamed(context, "/anotacoes");
        break;

      case "Chat":
        Navigator.pushNamed(context, "/chat");
        break;

      case "Sobre":
        Navigator.pushNamed(context, "/sobre");
        break;

      case "Sair":
        await logout(context);
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Funcionalidade não encontrada: $funcionalidade')),
        );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao sair: $e")),
      );
    }
  }
}
