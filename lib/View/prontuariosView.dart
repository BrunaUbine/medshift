import 'package:flutter/material.dart';
import 'package:meuapppdv/Controller/prontuarioController.dart';
import '../AppState.dart';
import '../model/paciente.dart';
import '../View/tela_compartilhadaView.dart';

class ProntuariosView extends StatefulWidget {
  const ProntuariosView({super.key});

  @override
  State<ProntuariosView> createState() => _ProntuariosViewState();
}

class _ProntuariosViewState extends State<ProntuariosView> {
  final controller = ProntuarioController();
  int? pacienteSelecionado;

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);
    final pacientes = state.pacientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prontuário Clínico'),
        actions: [
          buildPopupMenu(context), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: pacienteSelecionado,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Paciente'),
              items: pacientes.map((Paciente p) {
                return DropdownMenuItem(value: p.id, child: Text(p.nome));
              }).toList(),
              onChanged: (v) => setState(() => pacienteSelecionado = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.tituloCtl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descricaoCtl,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pacienteSelecionado == null
                  ? null
                  : () => controller.adicionarAnotacao(
                        pacienteSelecionado!,
                        () => setState(() {}),
                      ),
              child: const Text('Salvar Anotação'),
            ),
            const Divider(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico de Prontuário',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: controller
                    .listarPorPaciente(pacienteSelecionado ?? -1)
                    .map((a) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(a.titulo),
                            subtitle: Text(a.descricao),
                            trailing: Text(
                              '${a.criadoEm.day}/${a.criadoEm.month}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
