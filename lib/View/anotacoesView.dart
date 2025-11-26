import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/Controller/anotacoesController.dart';
import 'package:medshift/View/components/popup_menu.dart';

class AnotacoesView extends StatelessWidget {
  const AnotacoesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnotacoesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Anotações",
          style: TextStyle(color: Colors.white),
        ),
        actions: [buildPopupMenu(context)],
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Nova Anotação",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: controller.textoCtl,
                      decoration: const InputDecoration(
                        labelText: "Digite sua anotação",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () async {
                        final erro = await controller.addAnotacao();

                        if (!context.mounted) return;

                        if (erro != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(erro)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.listarAnotacoesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhuma anotação registrada.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final item = docs[index];
                      final data = item.data() as Map<String, dynamic>;
                      final texto = data["texto"] ?? "";

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            texto,
                            style: const TextStyle(fontSize: 16),
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final erro = await controller.removerAnotacao(item.id);

                              if (erro != null && context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(erro)));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
