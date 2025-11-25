import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/Model/medicamentos.dart';

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
        title: Text('Histórico de $nomePaciente'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: StreamBuilder<List<Medicamento>>(
        stream: controller.historicoMedicamentos(pacienteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum medicamento registrado.'));
          }

          final lista = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final med = lista[index];

              final created = med.criadoEm;
              final dateStr = '${created.day.toString().padLeft(2, '0')}/'
                  '${created.month.toString().padLeft(2, '0')}/'
                  '${created.year} ${created.hour.toString().padLeft(2, '0')}:'
                  '${created.minute.toString().padLeft(2, '0')}';

              return Card(
                child: ListTile(
                  title: Text(med.nome),
                  subtitle: Text(
                    '${med.dose} • ${med.horario}\n'
                    'Obs: ${med.observacao}\n'
                    'Aplicado em: $dateStr',
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
