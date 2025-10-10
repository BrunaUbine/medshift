import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/pacientesController.dart';
import '../bancoDeDados/banco_de_dados_simulado.dart';


class PacientesView extends StatefulWidget {
  const PacientesView({super.key});

  @override
  State<PacientesView> createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  final controller = PacientesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pacientes'),
        actions: [_menu(context)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.nomeCtl,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      controller.addPaciente(() => setState(() {}));
                    }),
                    child: const Text('Salvar Paciente'),
                  ),
             const Divider(height: 32),
              const Text('Pacientes Cadastrados',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
            ...BancoDeDadosSimulado.pacientes.map((p) => Card(
                    child: ListTile(
                      title: Text(p.nome),
                      subtitle: Text('Acompanhante: ${p.acompanhante}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() {
                          controller.removerPaciente(p.id, () => setState(() {}));
                        }),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );
  } PopupMenuButton _menu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => Navigator.pushNamed(context, value),
      itemBuilder: (_) => const [
        PopupMenuItem(value: '/prontuario', child: Text('Prontuário')),
        PopupMenuItem(value: '/medicamentos', child: Text('Medicamentos')),
        PopupMenuItem(value: '/anotacoes', child: Text('Anotações')),
        PopupMenuItem(value: '/agenda', child: Text('Agenda')),
        PopupMenuItem(value: '/sobre', child: Text('Sobre')),
      ],
    );
  }
}