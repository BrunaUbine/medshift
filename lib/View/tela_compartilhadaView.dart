import 'package:flutter/material.dart';

Widget buildPopupMenu(BuildContext context) {
  return PopupMenuButton<String>(
    onSelected: (v) {
      switch (v) {
        case 'pacientes':
          Navigator.pushNamed(context, '/pacientes');
          break;
        case 'prontuario':
          Navigator.pushNamed(context, '/prontuario');
          break;
        case 'medicamentos':
          Navigator.pushNamed(context, '/medicamentos');
          break;
        case 'anotacoes':
          Navigator.pushNamed(context, '/anotacoes');
          break;
        case 'agenda':
          Navigator.pushNamed(context, '/agenda');
          break;
        case 'sobre':
          Navigator.pushNamed(context, '/sobre');
          break;
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(value: 'pacientes', child: Text('Pacientes')),
      PopupMenuItem(value: 'prontuario', child: Text('Prontuário')),
      PopupMenuItem(value: 'medicamentos', child: Text('Medicamentos')),
      PopupMenuItem(value: 'anotacoes', child: Text('Anotações')),
      PopupMenuItem(value: 'agenda', child: Text('Agenda')),
      PopupMenuItem(value: 'sobre', child: Text('Sobre')),
    ],
  );
}
