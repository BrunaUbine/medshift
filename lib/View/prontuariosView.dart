import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/Controller/prontuarioController.dart';
import 'package:medshift/View/components/popup_menu.dart';

class ProntuariosView extends StatefulWidget {
  const ProntuariosView({super.key});

  @override
  State<ProntuariosView> createState() => _ProntuariosViewState();
}

class _ProntuariosViewState extends State<ProntuariosView> {
  final controller = ProntuarioController();
  String? pacienteSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prontuário Clínico"),
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pacientes")
                  .orderBy("nome")
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snap.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "Nenhum paciente cadastrado.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: pacienteSelecionado,
                  decoration: const InputDecoration(
                    labelText: "Selecione o paciente",
                  ),
                  items: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: d.id, // usamos o ID do Firestore
                      child: Text(data["nome"]),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => pacienteSelecionado = v),
                );
              },
            ),

            const SizedBox(height: 20),

            if (pacienteSelecionado != null) ...[
              TextFormField(
                controller: controller.tituloCtl,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: controller.descricaoCtl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Salvar anotação"),
                onPressed: () async {
                  final erro = await controller.adicionarAnotacao(
                    pacienteSelecionado!,
                  );

                  if (!mounted) return;

                  if (erro != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erro)),
                    );
                  }
                },
              ),

              const Divider(height: 32),

              const Text(
                "Histórico de Prontuário",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.listarPorPacienteStream(
                    pacienteSelecionado!,
                  ),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snap.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma anotação encontrada.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final dt = (data["criadoEm"] as Timestamp?)?.toDate();

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(data["titulo"]),
                            subtitle: Text(data["descricao"]),
                            trailing: Text(
                              dt != null
                                  ? "${dt.day}/${dt.month}/${dt.year}"
                                  : "",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
