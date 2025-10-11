import 'package:flutter/material.dart';
import 'package:medshift/Controller/prontuarioController.dart';
import '../AppState.dart';
import '../model/paciente.dart';
import 'tela_compartilhadaView.dart';

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
        actions: [buildPopupMenu(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: pacientes.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum paciente cadastrado.\nCadastre um paciente primeiro.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    value: pacienteSelecionado,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Selecione o paciente',
                    ),
                    items: pacientes.map((Paciente p) {
                      return DropdownMenuItem(value: p.id, child: Text(p.nome));
                    }).toList(),
                    onChanged: (v) => setState(() => pacienteSelecionado = v),
                  ),
                  const SizedBox(height: 20),

                  if (pacienteSelecionado == null)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Selecione um paciente para visualizar ou adicionar anotações.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ),
                    )
                  else ...[
                    TextFormField(
                      controller: controller.tituloCtl,
                      decoration:
                          const InputDecoration(labelText: 'Título da Anotação'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.descricaoCtl,
                      decoration:
                          const InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.adicionarAnotacao(
                          pacienteSelecionado!,
                          () => setState(() {}),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Anotação'),
                    ),
                    const Divider(height: 32),

                    const Text(
                      'Histórico de Prontuário',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final anotacoes = controller
                                  .listarPorPaciente(pacienteSelecionado!)
                                  .toList();

                          if (anotacoes.isEmpty) {
                            return const Center(
                              child: Text(
                                'Nenhuma anotação registrada para este paciente.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: anotacoes.length,
                            itemBuilder: (context, i) {
                              final a = anotacoes[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(a.titulo),
                                  subtitle: Text(a.descricao),
                                  trailing: Text(
                                    '${a.criadoEm.day}/${a.criadoEm.month}/${a.criadoEm.year}',
                                    style:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
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
