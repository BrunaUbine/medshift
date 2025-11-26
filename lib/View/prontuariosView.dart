import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/Controller/prontuarioController.dart';
import 'package:medshift/View/components/popup_menu.dart';
import 'package:provider/provider.dart';

class ProntuariosView extends StatefulWidget {
  final String pacienteId;
  final String nomePaciente;

  const ProntuariosView({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  @override
  State<ProntuariosView> createState() => _ProntuariosViewState();
}

class _ProntuariosViewState extends State<ProntuariosView> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProntuarioController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Prontuário — ${widget.nomePaciente}"),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nova Anotação",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.tituloCtl,
                      decoration: const InputDecoration(
                        labelText: "Título",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.descricaoCtl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "Descrição"),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () async {
                        final erro = await controller
                            .adicionarAnotacao(widget.pacienteId);

                        if (!mounted) return;

                        if (erro != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(erro)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Anotação salva!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Histórico do Prontuário",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.listarPorPacienteStream(widget.pacienteId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma anotação registrada.",
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
                          title: Text(
                            data["titulo"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(data["descricao"]),

                          trailing: Text(
                            dt != null
                                ? "${dt.day}/${dt.month}/${dt.year}"
                                : "",
                            style: const TextStyle(color: Colors.grey),
                          ),

                          onLongPress: () async {
                            final erro =
                                await controller.removerAnotacao(doc.id);

                            if (!mounted) return;

                            if (erro != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(erro)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Anotação removida."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
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
