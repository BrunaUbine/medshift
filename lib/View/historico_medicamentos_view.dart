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
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: Text(
          'Histórico - $nomePaciente',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: controller.historico(pacienteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum registro encontrado.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),

            itemBuilder: (context, index) {
              final item = docs[index];
              final data = item.data() as Map<String, dynamic>;

              final nome = data['nome'] ?? '';
              final dose = data['dose'] ?? '';
              final horario = data['horario'] ?? '';
              final obs = data['observacao'] ?? '';

              final ts = data['criadoEm'] as Timestamp?;
              final date = ts?.toDate();

              final dateStr = date != null
                  ? '${date.day.toString().padLeft(2, '0')}/'
                      '${date.month.toString().padLeft(2, '0')}/'
                      '${date.year}  '
                      '${date.hour.toString().padLeft(2, '0')}:'
                      '${date.minute.toString().padLeft(2, '0')}'
                  : 'Sem data';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.medication,
                            color: Color(0xFF1976D2),
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Dose: $dose',
                        style: const TextStyle(fontSize: 15),
                      ),

                      Text(
                        'Horário: $horario',
                        style: const TextStyle(fontSize: 15),
                      ),

                      if (obs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Obs: $obs',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
