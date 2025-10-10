import 'package:flutter/material.dart';
import 'tela_compartilhadaView.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        actions: [buildPopupMenu(context)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nome do App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Objetivo: Exemplo de prontuário clínico e gerenciamento simples de pacientes.'),
              SizedBox(height: 12),
              Text('Integrantes:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('- Bruna (autor)'),
              SizedBox(height: 16),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Voltar')))
            ]),
          ),
        ),
      ),
    );
  }
}
