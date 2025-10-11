import 'package:flutter/material.dart';
import 'package:medshift/Controller/agendaController.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  final controller = AgendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
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
                    const Text('Novo Compromisso', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.descCtl,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.dataSelecionada == null
                                ? 'Nenhuma data selecionada'
                                : '${controller.dataSelecionada!.day}/${controller.dataSelecionada!.month}/${controller.dataSelecionada!.year} - '
                                  '${controller.dataSelecionada!.hour.toString().padLeft(2, '0')}:${controller.dataSelecionada!.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                          onPressed: () => controller.selecionarData(context, () => setState(() {})),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        controller.adicionarEvento(() => setState(() {}));
                      }),
                      child: const Text('Salvar Evento'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: controller.listarEventos().map((e) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(e.descricao),
                      subtitle: Text(
                        '${e.dataHora.day}/${e.dataHora.month}/${e.dataHora.year} • ${e.dataHora.hour}:${e.dataHora.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.grey),
                      ),
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
