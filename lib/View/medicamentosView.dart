import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/View/components/popup_menu.dart';

import 'package:medshift/Controller/api_medicamentos_controller.dart';
import 'package:medshift/View/api_medicamentos_select_view.dart';
import 'package:medshift/View/historico_medicamentos_view.dart';

class MedicamentosView extends StatefulWidget {
  final String pacienteId;
  final String nomePaciente;

  const MedicamentosView({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Medicamentos — ${widget.nomePaciente}"),
        backgroundColor: const Color(0xFF1976D2),
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: controller,
                        child: HistoricoMedicamentosView(
                          pacienteId: widget.pacienteId,
                          nomePaciente: widget.nomePaciente,
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history, color: Colors.blue),
                label: const Text(
                  "Histórico de Medicamentos",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Adicionar Medicamento",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.nomeCtl,
                            decoration:
                                const InputDecoration(labelText: "Nome"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final nomeSelecionado =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) =>
                                      ApiMedicamentosController(),
                                  child:
                                      const ApiMedicamentosSelectView(),
                                ),
                              ),
                            );

                            if (nomeSelecionado != null) {
                              setState(() {
                                controller.nomeCtl.text =
                                    nomeSelecionado;
                              });
                            }
                          },
                          child: const Text("ANVISA"),
                        ),
                      ],
                    ),

                    TextField(
                        controller: controller.doseCtl,
                        decoration:
                            const InputDecoration(labelText: "Dose")),
                    TextField(
                        controller: controller.horarioCtl,
                        decoration:
                            const InputDecoration(labelText: "Horário")),
                    TextField(
                        controller: controller.obsCtl,
                        decoration:
                            const InputDecoration(labelText: "Observação")),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () async {
                        final erro = await controller.adicionarMedicamento(
                          widget.pacienteId,
                        );

                        if (!mounted) return;

                        if (erro != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(erro)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Medicamento salvo!")),
                          );
                        }
                      },
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.listarPorPacienteStream(
                  widget.pacienteId,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                          "Nenhum medicamento cadastrado para este paciente.",
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView(
                    children: docs.map((doc) {
                      final data =
                          doc.data() as Map<String, dynamic>? ?? {};

                      return Card(
                        child: ListTile(
                          title: Text(data["nome"] ?? ''),
                          subtitle: Text(
                            "${data["dose"] ?? ''} • ${data["horario"] ?? ''}\nObs: ${data["observacao"] ?? ''}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () async {
                              final erro =
                                  await controller.removerMedicamento(
                                      doc.id);

                              if (!mounted) return;

                              if (erro != null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                        SnackBar(content: Text(erro)));
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
