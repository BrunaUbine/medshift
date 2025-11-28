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
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "Anotações",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _formulario(controller),
            const SizedBox(height: 22),
            Expanded(child: _listaAnotacoes(controller)),
          ],
        ),
      ),
    );
  }


  Widget _formulario(AnotacoesController controller) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Nova Anotação",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: controller.textoCtl,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Digite sua anotação",
                prefixIcon: const Icon(Icons.edit, color: Color(0xFF1976D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () async {
                final erro = await controller.addAnotacao();
                if (erro != null) return;

                controller.textoCtl.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Salvar Anotação"),
            ),
          ],
        ),
      ),
    );
  }


  Widget _listaAnotacoes(AnotacoesController controller) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.listarAnotacoesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1976D2)),
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

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final item = docs[i];
            final data = item.data() as Map<String, dynamic>;
            final texto = data["texto"] ?? "";

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),

                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF1976D2).withOpacity(0.15),
                  child: const Icon(Icons.note_alt, color: Color(0xFF1976D2)),
                ),

                title: Text(
                  texto,
                  style: const TextStyle(fontSize: 16),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    controller.removerAnotacao(item.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
