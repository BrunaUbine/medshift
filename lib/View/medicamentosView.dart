import 'package:flutter/material.dart';
import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';


class MedicamentosView extends StatefulWidget {
  const MedicamentosView({super.key});

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  final controller = MedicamentosController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos'),
        actions: [
          buildPopupMenu(context), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Adicionar Medicamento', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(controller: controller.nomeCtl, decoration: const InputDecoration(labelText: 'Nome')),
                    const SizedBox(height: 8),
                    TextFormField(controller: controller.doseCtl, decoration: const InputDecoration(labelText: 'Dose')),
                    const SizedBox(height: 8),
                    TextFormField(controller: controller.horarioCtl, decoration: const InputDecoration(labelText: 'Horário')),
                    const SizedBox(height: 8),
                    TextFormField(controller: controller.obsCtl, decoration: const InputDecoration(labelText: 'Observação')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        controller.adicionarMedicamento(0, () => setState(() {})); // Sem paciente vinculado ainda
                      }),
                      child: const Text('Salvar Medicamento'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: controller.listarTodos().map((m) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(m.nome),
                      subtitle: Text('${m.dose} - ${m.horario}'),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
