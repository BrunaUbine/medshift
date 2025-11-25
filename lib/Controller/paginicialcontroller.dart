import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_routes.dart';

class PaginaInicialController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> funcionalidadeNames = [
    "Prontuários",
    "Pacientes",
    "Agenda",
    "Anotações",
    "Sobre",
    "Sair",
  ];

  final Map<String, IconData> funcionalidadeIcons = {
    "Prontuários": Icons.note,
    "Pacientes": Icons.people_alt,
    "Agenda": Icons.calendar_month,
    "Anotações": Icons.edit_note,
    "Sobre": Icons.info_outline,
    "Sair": Icons.logout,
  };

  List<String> get funcionalidades => funcionalidadeNames;

  IconData getIconFor(String f) => funcionalidadeIcons[f] ?? Icons.help_outline;

  void aoClicar(BuildContext context, String funcionalidade) async {
    switch (funcionalidade) {
      case "Prontuários":
        Navigator.pushNamed(context, AppRoutes.prontuarios);
        break;

      case "Pacientes":
        Navigator.pushNamed(context, AppRoutes.pacientes);
        break;

      case "Agenda":
        Navigator.pushNamed(context, AppRoutes.agenda);
        break;

      case "Anotações":
        Navigator.pushNamed(context, AppRoutes.anotacoes);
        break;

      case "Sobre":
        Navigator.pushNamed(context, AppRoutes.sobre);
        break;

      case "Sair":
        await logout(context);
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Funcionalidade não encontrada")),
        );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao sair: $e")),
      );
    }
  }
}
