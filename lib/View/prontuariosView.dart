import 'package:flutter/material.dart';
import '../AppState.dart';
import '../model/entrada_paciente.dart';
import '../bancoDeDados/banco_de_dados_simulado.dart';
import 'package:intl/intl.dart';
import 'tela_compartilhadaView.dart';

class ProntuarioView extends StatefulWidget {
  const ProntuarioView({super.key});

  @override
  State<ProntuarioView> createState() => _ProntuarioViewState();
}

class _ProntuarioViewState extends State<ProntuarioView> {
  final _tituloCtl = TextEditingController();
  final _descCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);
    final int? patienteIdArg = ModalRoute.of(context)!.settings.arguments as int?;
    final int? idPaciente = patienteIdArg;
    final paciente = idPaciente!= null ? BancoDeDadosSimulado.selecionePorIdPaciente(idPaciente) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Prontuário Clínico'),
        actions: [buildPopupMenu(context)],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          if (paciente != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(child: Text(paciente.nome.isNotEmpty ? paciente.nome[0].toUpperCase() : 'P')),
                title: Text(paciente.nome),
                subtitle: Text('Tel: ${paciente.telefone} • Acomp.: ${paciente.acompanhante.isEmpty ? '-' : paciente.acompanhante}'),
              ),
            ),
          SizedBox(height: 8),
          Expanded(
            child: AnimatedBuilder(
              animation: state,
              builder: (context, _) {
                final entradas = state.prontuarios.where((e) => e.idPaciente == (idPaciente ?? -1)).toList();
                if (entradas.isEmpty) {
                  return Center(child: Text('Nenhum registro de prontuário para este paciente.'));
                }
                entradas.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
                return ListView.separated(
                  itemCount: entradas.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final Entrada_paciente e = entradas[i];
                    final df = DateFormat('dd/MM/yyyy HH:mm');
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text(e.descricao),
                            SizedBox(height: 8),
                            Align(alignment: Alignment.bottomRight, child: Text(df.format(e.criadoEm), style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text('Adicionar anotação ao prontuário', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextField(controller: _tituloCtl, decoration: InputDecoration(labelText: 'Título')),
                  SizedBox(height: 8),
                  TextField(controller: _descCtl, decoration: InputDecoration(labelText: 'Descrição'), maxLines: 3),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (idPaciente == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecione um paciente antes (via tela Pacientes).')));
                        return;
                      }
                      if (_tituloCtl.text.trim().isEmpty || _descCtl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha título e descrição.')));
                        return;
                      }
                      state.addEntradaPaciente(idPaciente, _tituloCtl.text.trim(), _descCtl.text.trim());
                      _tituloCtl.clear();
                      _descCtl.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: SizedBox(width: double.infinity, child: Center(child: Text('Salvar no prontuário'))),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
