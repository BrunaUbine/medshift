import 'package:flutter/material.dart';
import 'package:medshift/Controller/anotacoesController.dart';
import '../AppState.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';

class AnotacoesView extends StatefulWidget {
  const AnotacoesView({super.key});

  @override
  State<AnotacoesView> createState() => _AnotacoesViewState();
}

class _AnotacoesViewState extends State<AnotacoesView> {
  final controller = AnotacoesController();

  @override
  Widget build(BuildContext context) {
    final state = AppStateWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anotações'),
        actions: [
          buildPopupMenu(context), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Nova Anotação', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.textoCtl,
                      decoration: const InputDecoration(labelText: 'Digite sua anotação'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        controller.addAnotacao(() => setState(() {}));
                      }),
                      child: const Text('Salvar Anotação'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: state,
                builder: (context, _) {
                  final anotacoes = controller.listarAnotacoes();
                  if (anotacoes.isEmpty) {
                    return const Center(child: Text('Nenhuma anotação cadastrada.'));
                  }
                  return ListView.separated(
                    itemCount: anotacoes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final a = anotacoes[i];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(a.texto),
                          subtitle: Text(
                            '${a.criadoEm.day}/${a.criadoEm.month}/${a.criadoEm.year}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
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
