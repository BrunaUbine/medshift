import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/View/components/popup_menu.dart';

class MedicosView extends StatelessWidget {
  const MedicosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Médicos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("usuarios")
              .orderBy("nomeLower")
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Nenhum médico encontrado.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView(
              children: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1976D2),
                      child: Icon(Icons.person, color: Colors.white),
                    ),

                    title: Text(
                      data["nome"] ?? "Nome não informado",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    subtitle: Text(
                      "Email: ${data["email"] ?? "-"}\n"
                      "Telefone: ${data["telefone"] ?? "-"}",
                    ),

                    onTap: () {
                      _abrirDetalhes(context, data);
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _abrirDetalhes(BuildContext context, Map<String, dynamic> medico) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(medico["nome"] ?? "Médico"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Email: ${medico["email"] ?? "-"}"),
            const SizedBox(height: 8),
            Text("Telefone: ${medico["telefone"] ?? "-"}"),
            const SizedBox(height: 8),
            Text("Nascimento: ${medico["dtNascimento"] ?? "-"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }
}
