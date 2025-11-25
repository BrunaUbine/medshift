import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_routes.dart';

class PagInicialController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> funcionalidadeNames = [
    "Protuários",
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
    "Chat": Icons.chat_bubble_outline,
    "Sobre": Icons.info_outline,
    "Sair": Icons.logout,
  };

  List<String> get funcionalidades => funcionalidadeNames;

  IconData getIconFor(String f) =>
      funcionalidadeIcons[f] ?? Icons.help_outline;

  void aoClicar(BuildContext context, String funcionalidade) async {
    switch (funcionalidade) {
      case "Prontuários":
        AppRoutes.prontuarios;
        break;
        
      case "Pacientes":
        AppRoutes.pacientes;
        break;

      case "Agenda":
        AppRoutes.agenda;
        break;

      case "Anotações":
        AppRoutes.anotacoes;
        break;

      case "Sobre":
        AppRoutes.sobre;
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
