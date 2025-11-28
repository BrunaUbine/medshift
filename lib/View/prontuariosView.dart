import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medshift/Controller/prontuarioController.dart';

class ProntuariosView extends StatefulWidget {
  final String pacienteId;
  final String pacienteNome;

  const ProntuariosView({
    super.key,
    required this.pacienteId,
    required this.pacienteNome,
  });

  @override
  State<ProntuariosView> createState() => _ProntuariosViewState();
}

class _ProntuariosViewState extends State<ProntuariosView> {
  final controller = ProntuarioController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: Text(
          "Prontuário — ${widget.pacienteNome}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _formCard(),
            const SizedBox(height: 25),
            const Text(
              "Histórico de Anotações",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _listaAnotacoes()),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // CARD DO FORMULÁRIO
  // -------------------------------------------------------
  Widget _formCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.tituloCtl,
                decoration: const InputDecoration(
                  labelText: "Título",
                  prefixIcon: Icon(Icons.title, color: Color(0xFF1976D2)),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o título" : null,
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: controller.descricaoCtl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF1976D2)),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a descrição" : null,
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final erro =
                      await controller.adicionarAnotacao(widget.pacienteId);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          erro ?? "Anotação salva com sucesso!"),
                      backgroundColor:
                          erro == null ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: const Text(
                  "Salvar Anotação",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // LISTA DE ANOTAÇÕES
  // -------------------------------------------------------
  Widget _listaAnotacoes() {
    return StreamBuilder<QuerySnapshot>(
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
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),

                title: Text(
                  data["titulo"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    data["descricao"] ?? "",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dt != null
                          ? "${dt.day.toString().padLeft(2, '0')}/"
                            "${dt.month.toString().padLeft(2, '0')}/"
                            "${dt.year}"
                          : "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        final erro = await controller.removerAnotacao(doc.id);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              erro ?? "Anotação removida!",
                            ),
                            backgroundColor:
                                erro == null ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
