import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/Controller/prontuariocontroller.dart';
import 'package:medshift/Controller/medicamentosController.dart'; 
import 'package:provider/provider.dart';

class TelaCompartilhadaView extends StatelessWidget {
  final String pacienteId;
  final String pacienteNome;

  const TelaCompartilhadaView({
    super.key,
    required this.pacienteId,
    required this.pacienteNome,
  });

  @override
  Widget build(BuildContext context) {
    final prontuario = Provider.of<ProntuarioController>(context);
    final medicamentos = Provider.of<MedicamentosController>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Paciente: $pacienteNome"),
          backgroundColor: const Color(0xFF1976D2),
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: "Prontuário"),
              Tab(icon: Icon(Icons.medication), text: "Medicamentos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProntuarioTab(context, prontuario),
            _buildMedicamentosTab(context, medicamentos),
          ],
        ),
      ),
    );
  }



  Widget _buildProntuarioTab(
      BuildContext context, ProntuarioController controller) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: controller.listarPorPacienteStream(pacienteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Nenhuma anotação ainda."));
              }

              final docs = snapshot.data!.docs;

              return ListView(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(data['titulo']),
                      subtitle: Text(data['descricao']),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          final erro =
                              await controller.removerAnotacao(doc.id);

                          if (erro != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(erro)),
                            );
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

        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF1976D2),
            ),
            onPressed: () {
              _mostrarDialogoNovaAnotacao(context, controller);
            },
            icon: const Icon(Icons.add),
            label: const Text("Adicionar anotação"),
          ),
        )
      ],
    );
  }

  void _mostrarDialogoNovaAnotacao(
      BuildContext context, ProntuarioController controller) {
    controller.limparCampos();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nova anotação"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.tituloCtl,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: controller.descricaoCtl,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final erro = await controller.adicionarAnotacao(pacienteId);

              if (erro == null) {
                if (context.mounted) Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(erro)),
                );
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }


  Widget _buildMedicamentosTab(
      BuildContext context, MedicamentosController controller) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: controller.listarPorPacienteStream(pacienteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Nenhum medicamento cadastrado."),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView(
                children: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("${data['nome']} — ${data['dose']}"),
                      subtitle: Text(
                          "Horário: ${data['horario']}\nObs: ${data['observacao']}"),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          final erro =
                              await controller.removerMedicamento(doc.id);

                          if (erro != null && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(erro)),
                            );
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

        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF1976D2),
            ),
            onPressed: () {
              _mostrarDialogoNovoMedicamento(context, controller);
            },
            icon: const Icon(Icons.add),
            label: const Text("Adicionar medicamento"),
          ),
        )
      ],
    );
  }

  void _mostrarDialogoNovoMedicamento(
      BuildContext context, MedicamentosController controller) {
    controller.limparCampos();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Novo medicamento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              decoration: const InputDecoration(labelText: "Observações"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final erro = await controller.adicionarMedicamento(pacienteId);

              if (erro == null && context.mounted) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(erro!)),
                );
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }
}
