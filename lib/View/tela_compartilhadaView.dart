import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/prontuarioController.dart';
import '../Controller/medicamentosController.dart';
import './prontuariosView.dart';
import './medicamentosView.dart';

class TelaCompartilhadaView extends StatelessWidget {
  final String pacienteId;
  final String pacienteNome;

  const TelaCompartilhadaView({
    super.key,
    required this.pacienteId,
    required this.pacienteNome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paciente: $pacienteNome"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOption(
            context,
            icon: Icons.receipt_long,
            title: "Prontuário",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => ProntuarioController(),
                    child: ProntuariosView(
                      pacienteId: pacienteId,
                      nomePaciente: pacienteNome,
                    ),
                  ),
                ),
              );
            },
          ),

          _buildOption(
            context,
            icon: Icons.medication,
            title: "Medicamentos",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => MedicamentosController(),
                    child: MedicamentosView(
                      pacienteId: pacienteId,
                      nomePaciente: pacienteNome,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 32, color: const Color(0xFF1976D2)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
