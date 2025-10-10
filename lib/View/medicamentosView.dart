import 'package:flutter/material.dart';
import '../AppState.dart';
import 'tela_compartilhadaView.dart';

class MedicamentosView extends StatefulWidget {
  const MedicamentosView({super.key});

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  final _nomeCtl = TextEditingController();
  final _doseCtl = TextEditingController();
  final _horarioCtl = TextEditingController();
  final _obsCtl = TextEditingController();
  final int _patientId = -1; // optional link; -1 = general

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicamentos'),
        actions: [buildPopupMenu(context)],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(children: [
                Text('Adicionar medicamento', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(controller: _nomeCtl, decoration: InputDecoration(labelText: 'Nome')),
                SizedBox(height: 8),
                TextField(controller: _doseCtl, decoration: InputDecoration(labelText: 'Dose')),
                SizedBox(height: 8),
                TextField(controller: _horarioCtl, decoration: InputDecoration(labelText: 'Horário')),
                SizedBox(height: 8),
                TextField(controller: _obsCtl, decoration: InputDecoration(labelText: 'Observação')),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_nomeCtl.text.trim().isEmpty) return;
                    state.addMedicamento(_patientId, _nomeCtl.text.trim(), _doseCtl.text.trim(), _horarioCtl.text.trim(), _obsCtl.text.trim());
                    _nomeCtl.clear(); _doseCtl.clear(); _horarioCtl.clear(); _obsCtl.clear();
                  },
                  child: SizedBox(width: double.infinity, child: Center(child: Text('Salvar medicamento'))),
                ),
              ]),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: state,
              builder: (context, _) {
                final meds = state.medicamentos;
                if (meds.isEmpty) return Center(child: Text('Nenhum medicamento cadastrado.'));
                return ListView.separated(
                  itemCount: meds.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final m = meds[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(m.nome),
                        subtitle: Text('${m.dose} • ${m.horario}\n${m.observacao}'),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
