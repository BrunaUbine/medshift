import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/anotacoesController.dart';

class AnotacoesView extends StatelessWidget {
  const AnotacoesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnotacoesController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Anotações")),
      body: StreamBuilder(
        stream: controller.listarAnotacoesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index];
              final texto = item['texto'];

              return ListTile(
                title: Text(texto),
              );
            },
          );
        },
      ),
    );
  }
}
