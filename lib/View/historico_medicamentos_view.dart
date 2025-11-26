import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/Controller/medicamentosController.dart';

class HistoricoMedicamentosView extends StatelessWidget {
  final String pacienteId;
  final String nomePaciente;

  const HistoricoMedicamentosView({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico - $nomePaciente',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: controller.historico(pacienteId)
,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum registro encontrado.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = docs[index];
              final data = item.data() as Map<String, dynamic>;

              final acao = data['acao'] ?? '';
              final obs = data['observacao'] ?? '';
              final ts = data['criadoEm'] as Timestamp?;
              final date = ts?.toDate();

              final dateStr = date != null
                  ? '${date.day.toString().padLeft(2, '0')}/'
                      '${date.month.toString().padLeft(2, '0')}/'
                      '${date.year} - '
                      '${date.hour.toString().padLeft(2, '0')}:'
                      '${date.minute.toString().padLeft(2, '0')}'
                  : 'Sem data';

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Color(0xFF1976D2),
                    size: 30,
                  ),
                  title: Text(
                    acao,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    'Obs: $obs\n$dateStr',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
