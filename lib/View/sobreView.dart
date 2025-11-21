import 'package:flutter/material.dart';
import 'package:medshift/View/components/popup_menu.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        actions: [
          buildPopupMenu(context),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MedShift',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'O MedShift é um aplicativo desenvolvido para auxiliar '
                  'profissionais de saúde no gerenciamento de pacientes, '
                  'prontuários, medicamentos, anotações e comunicação eficiente '
                  'entre equipes durante a troca de turnos.',
                  style: TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Versão: 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Desenvolvido por:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Bruna Luiza Nunes Ubine',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Projeto desenvolvido como parte do Trabalho de Conclusão de Curso '
                  'em Análise e Desenvolvimento de Sistemas.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
