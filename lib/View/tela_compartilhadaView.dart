import 'package:flutter/material.dart';
import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/View/medicamentosView.dart';
import 'package:medshift/View/prontuariosView.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: Text(
          pacienteNome,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _tile(
              icon: Icons.description,
              title: "Prontuário",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProntuariosView(
                      pacienteId: pacienteId,
                      pacienteNome: pacienteNome,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _tile(
              icon: Icons.medical_services,
              title: "Medicamentos",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicamentosView(
                      pacienteId: pacienteId,
                      pacienteNome: pacienteNome,
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1976D2).withOpacity(0.15),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
