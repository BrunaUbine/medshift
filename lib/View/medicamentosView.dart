import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/View/components/popup_menu.dart';

class MedicamentosView extends StatefulWidget {
  const MedicamentosView({super.key});

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  String? pacienteSelecionado;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicamentos"),
        backgroundColor: const Color(0xFF1976D2),
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pacientes")
                  .orderBy("nome")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Text(
                    "Nenhum paciente cadastrado.",
                    style: TextStyle(color: Colors.grey),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: pacienteSelecionado,
                  decoration: const InputDecoration(
                    labelText: "Selecione o paciente",
                  ),
                  items: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(data["nome"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      pacienteSelecionado = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            if (pacienteSelecionado == null)
              const Expanded(
                child: Center(
                  child: Text(
                    "Selecione um paciente para ver os medicamentos.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              "Adicionar Medicamento",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(height: 10),

                            TextField(
                              controller: controller.nomeCtl,
                              decoration: const InputDecoration(labelText: "Nome"),
                            ),
                            TextField(
                              controller: controller.doseCtl,
                              decoration: const InputDecoration(labelText: "Dose"),
                            ),
                            TextField(
                              controller: controller.horarioCtl,
                              decoration: const InputDecoration(labelText: "Horário"),
                            ),
                            TextField(
                              controller: controller.obsCtl,
                              decoration: const InputDecoration(labelText: "Observação"),
                            ),

                            const SizedBox(height: 10),

                            ElevatedButton(
                              onPressed: () async {
                                final erro = await controller
                                    .adicionarMedicamento(pacienteSelecionado!);

                                if (erro != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(erro)),
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
                        stream: controller.listarPorPacienteStream(pacienteSelecionado!),
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
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView(
                            children: docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              return Card(
                                child: ListTile(
                                  title: Text(data["nome"]),
                                  subtitle: Text(
                                    "${data["dose"]} • ${data["horario"]}\nObs: ${data["observacao"]}",
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      controller.removerMedicamento(doc.id);
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
          ],
        ),
      ),
    );
  }
}
