import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medshift/View/components/popup_menu.dart';

class MedicosView extends StatelessWidget {
  const MedicosView({super.key});

  String formatarData(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    try {
      final data = DateTime.parse(iso);
      return DateFormat('dd/MM/yyyy').format(data);
    } catch (e) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "Médicos Cadastrados",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final data = docs[index].data() as Map<String, dynamic>;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF1976D2),
                      child: Text(
                        (data["nome"] ?? "?").toString().substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      data["nome"] ?? "Nome não informado",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Email: ${data["email"] ?? "-"}\n"
                        "Telefone: ${data["telefone"] ?? "-"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    onTap: () {
                      _abrirDetalhes(context, data);
                    },
                  ),
                );
              },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        title: Text(
          medico["nome"] ?? "Médico",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${medico["email"] ?? "-"}"),
            const SizedBox(height: 8),
            Text("Telefone: ${medico["telefone"] ?? "-"}"),
            const SizedBox(height: 8),
            Text("Nascimento: ${formatarData(medico["dtNascimento"])}"),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Fechar",
              style: TextStyle(color: Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }
}
