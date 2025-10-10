import 'package:flutter/material.dart';


class PagInicialController extends ChangeNotifier {
  final List<String> funcionalidadeNames = [
    "Pacientes",
    "Prontuário",
    "Agenda",
    "Medicamentos",
    "Anotações",
    "Sobre",
  ];

    final Map<String, IconData> funcionalidadeIcons = {
    "Pacientes": Icons.people_alt,
    "Prontuário": Icons.medical_services,
    "Agenda": Icons.calendar_month,
    "Medicamentos": Icons.local_pharmacy,
    "Anotações": Icons.edit_note,
    "Sobre": Icons.info_outline,
  };
    List<String> get funcionalidades => funcionalidadeNames;

  
  IconData getIconFor(String funcionalidade) {
    return funcionalidadeIcons[funcionalidade] ?? Icons.help_outline;
  }

  void aoClicar(BuildContext context, String funcionalidade) {
    String route = "";

    switch (funcionalidade) {
      case "Pacientes":
        route = "/pacientes";
        break;
      case "Prontuário":
        route = "/prontuarios";
        break;
      case "Agenda":
        route = "/agenda";
        break;
      case "Medicamentos":
        route = "/medicamentos";
        break;
      case "Anotações":
        route = "/anotacoes";
        break;
      case "Sobre":
        route = "/sobre";
        break;
      default:

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Funcionalidade $funcionalidade não encontrada.')),
        );
        return;
    }


    Navigator.pushNamed(context, route);
  }
}
