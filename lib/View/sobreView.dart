import 'package:flutter/material.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';


class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        actions: [
          buildPopupMenu(context), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'MedShift',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  'O MedShift é um aplicativo desenvolvido para auxiliar profissionais de saúde '
                  'no gerenciamento de pacientes, prontuários, medicamentos e anotações de forma prática e segura.',
                ),
                SizedBox(height: 12),
                Text(
                  'Versão: 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 12),
                Text(
                  'Desenvolvido por: Bruna Luiza Nunes Ubine',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
