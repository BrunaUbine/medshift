import 'package:flutter/material.dart';
import '../AppState.dart';
import 'tela_compartilhadaView.dart';

class AnotacoesView extends StatefulWidget {
  const AnotacoesView({super.key});

  @override
  State<AnotacoesView> createState() => _AnotacoesViewState();
}

class _AnotacoesViewState extends State<AnotacoesView> {
  final _textCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Anotações'), actions: [buildPopupMenu(context)]),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(children: [
                TextField(controller: _textCtl, decoration: InputDecoration(labelText: 'Escreva uma anotação'), maxLines: 3),
                SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () {
                      if (_textCtl.text.trim().isEmpty) return;
                      state.addAnotacao(_textCtl.text.trim());
                      _textCtl.clear();
                    },
                    child: SizedBox(width: double.infinity, child: Center(child: Text('Adicionar')))),
              ]),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: state,
              builder: (context, _) {
                final items = state.anotacoes.reversed.toList();
                if (items.isEmpty) return Center(child: Text('Nenhuma anotação.'));
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final a = items[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(a.texto),
                        subtitle: Text(a.criadoEm.toString()),
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
