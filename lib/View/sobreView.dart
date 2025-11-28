import 'package:flutter/material.dart';
import 'package:medshift/View/components/popup_menu.dart';

class SobreView extends StatelessWidget {
  const SobreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text(
          'Sobre o App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          buildPopupMenu(context),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'MedShift',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'O MedShift é um aplicativo desenvolvido para auxiliar '
                    'profissionais da saúde no gerenciamento de pacientes, '
                    'prontuários, medicamentos e comunicação eficiente durante '
                    'a troca de turnos.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Versão do aplicativo:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Desenvolvido por:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Bruna Luiza Nunes Ubine',
                    style: TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Este projeto foi desenvolvido como parte do Trabalho de '
                    'Conclusão de Curso (TCC) do curso de Análise e '
                    'Desenvolvimento de Sistemas.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
