import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medshift/Controller/prontuarioController.dart';

class ProntuariosView extends StatefulWidget {
  final String pacienteId;
  final String? pacienteNome; 
  const ProntuariosView({
    super.key,
    required this.pacienteId,
    this.pacienteNome,
  });

  @override
  State<ProntuariosView> createState() => _ProntuariosViewState();
}

class _ProntuariosViewState extends State<ProntuariosView> {
  final controller = ProntuarioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pacienteNome ?? "Prontuário"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                final erro = await controller.adicionarAnotacao(widget.pacienteId);
                if (!mounted) return;
                if (erro != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(erro)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Anotação salva!")),
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
                stream: controller.listarPorPacienteStream(widget.pacienteId),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snap.hasData || snap.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma anotação encontrada.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final docs = snap.data!.docs;

                  return ListView(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final dt = (data["criadoEm"] as Timestamp?)?.toDate();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(data["titulo"] ?? ""),
                          subtitle: Text(data["descricao"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dt != null
                                    ? "${dt.day}/${dt.month}/${dt.year}"
                                    : "",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () async {
                                  final erro = await controller.removerAnotacao(doc.id);
                                  if (erro != null && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(erro)),
                                    );
                                  }
                                },
                              ),
                            ],
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
