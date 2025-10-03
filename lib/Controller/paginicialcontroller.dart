import 'package:flutter/material.dart';

class paginaInicialController extends ChangeNotifier {
  final List<String> funcionalidades = [
    "Pacientes",
    "Prontuário",
    "Agenda",
    "Medicamentos",
    "Anotações",
    "Sobre",
  ];
  void aoClicar(BuildContext context, String funcionalidade) {
    switch (funcionalidade) {
      case "Pacientes":
        Navigator.pushNamed(context, "/pacientesView");
        break;
      case "Prontuário":
        Navigator.pushNamed(context, "/prontuario");
        break;
      case "Agenda":
        Navigator.pushNamed(context, "/agenda");
        break;
      case "Medicamentos":
        Navigator.pushNamed(context, "/medicamentos");
        break;
      case "Anotações":
        Navigator.pushNamed(context, "/anotacoes");
        break;
      case "Sobre":
        Navigator.pushNamed(context, "/sobre");
        break;
    }
  }
}


