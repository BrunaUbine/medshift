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
      appBar: AppBar(
        title: Text(
          pacienteNome,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.description, color: Color(0xFF1976D2)),
            title: const Text("Prontuário"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProntuariosView(pacienteId: pacienteId),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.medical_services, color: Color(0xFF1976D2)),
            title: const Text("Medicamentos"),
            onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>ChangeNotifierProvider(
                  create: (_) => MedicamentosController(),
                  child: MedicamentosView(
                    pacienteId: pacienteId,
                    pacienteNome: pacienteNome,
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
}
