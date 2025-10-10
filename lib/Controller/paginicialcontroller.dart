import 'package:flutter/material.dart';

/// O Controller gerencia a lógica e o estado da tela inicial.
/// Foi alterado de 'paginicialController' para 'PagInicialController'
/// para seguir a convenção de nomes PascalCase (padrão em Dart).
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

  /// Retorna o IconData para uma funcionalidade específica.
  IconData getIconFor(String funcionalidade) {
    return funcionalidadeIcons[funcionalidade] ?? Icons.help_outline; // Ícone padrão caso não encontre
  }
  /// Navega para a tela correspondente ao item clicado.
  void aoClicar(BuildContext context, String funcionalidade) {
    String route = "";

    switch (funcionalidade) {
      case "Pacientes":
        route = "/pacientes";
        break;
      case "Prontuário":
        route = "/prontuario";
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
        // Caso de segurança
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Funcionalidade $funcionalidade não encontrada.')),
        );
        return;
    }

    // Tenta navegar para a rota definida no MaterialApp
    Navigator.pushNamed(context, route);
  }
}
