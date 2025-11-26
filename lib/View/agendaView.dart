import 'package:flutter/material.dart';
import 'package:medshift/Controller/agendaController.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshift/View/components/popup_menu.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AgendaController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agenda",
          style: TextStyle(color: Colors.white),
        ),
        actions: [buildPopupMenu(context)],
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Novo Compromisso",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: controller.descCtl,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.dataSelecionada == null
                                ? "Nenhuma data selecionada"
                                : "${controller.dataSelecionada!.day.toString().padLeft(2, '0')}/"
                                  "${controller.dataSelecionada!.month.toString().padLeft(2, '0')}/"
                                  "${controller.dataSelecionada!.year}  "
                                  "${controller.dataSelecionada!.hour.toString().padLeft(2, '0')}:"
                                  "${controller.dataSelecionada!.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                          onPressed: () => controller.selecionarData(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () async {
                        final erro = await controller.adicionarEvento();

                        if (erro != null && mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(erro)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Evento adicionado!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        minimumSize: const Size(double.infinity, 45),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.listarEventosStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum compromisso registrado.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final dataHora = (data["dataHora"] as Timestamp).toDate();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            data["descricao"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${dataHora.day}/${dataHora.month}/${dataHora.year}  •  "
                            "${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final erro = await controller.removerEvento(doc.id);

                              if (erro != null && mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(erro)));
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
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
