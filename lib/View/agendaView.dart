import 'package:flutter/material.dart';
import '../AppState.dart';
import 'tela_compartilhadaView.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  final _descCtl = TextEditingController();
  DateTime? _selected;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(now.year - 2), lastDate: DateTime(now.year + 2));
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() {
      _selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Agenda'), actions: [buildPopupMenu(context)]),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(children: [
                TextField(controller: _descCtl, decoration: InputDecoration(labelText: 'Descrição')),
                SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Text(_selected == null ? 'Nenhuma data selecionada' : _selected.toString())),
                  TextButton(onPressed: () => _pickDate(context), child: Text('Selecionar')),
                ]),
                SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () {
                      if (_selected == null || _descCtl.text.trim().isEmpty) return;
                      state.addAgenda(_selected!, _descCtl.text.trim());
                      _selected = null;
                      _descCtl.clear();
                      setState(() {});
                    },
                    child: SizedBox(width: double.infinity, child: Center(child: Text('Adicionar compromisso')))),
              ]),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: state,
              builder: (context, _) {
                final items = state.agenda;
                if (items.isEmpty) return Center(child: Text('Nenhum compromisso.'));
                final sorted = List.from(items)..sort((a, b) => a.dataHora.compareTo(b.dataHora));
                return ListView.separated(
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final ev = sorted[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(ev.descricao),
                        subtitle: Text(ev.dataHora.toString()),
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
