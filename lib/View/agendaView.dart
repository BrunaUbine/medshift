import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Controller/agendaController.dart';
import '../View/components/popup_menu.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AgendaController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "Agenda",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormulario(controller),
            const SizedBox(height: 25),
            _buildListaEventos(controller),
          ],
        ),
      ),
    );
  }


  Widget _buildFormulario(AgendaController controller) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Novo Compromisso",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: controller.descCtl,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  prefixIcon: Icon(Icons.edit_calendar, color: Color(0xFF1976D2)),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Informe a descrição" : null,
              ),

              const SizedBox(height: 16),

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
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                    onPressed: () => controller.selecionarData(context),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final erro = await controller.adicionarEvento();

                    if (!mounted) return;

                    if (erro != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(erro)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Evento adicionado!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  "Salvar Evento",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildListaEventos(AgendaController controller) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.listarEventosStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 35),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "Nenhum compromisso registrado.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final dataHora = (data["dataHora"] as Timestamp).toDate();

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF1976D2).withOpacity(0.15),
                  child: const Icon(Icons.event, color: Color(0xFF1976D2)),
                ),

                title: Text(
                  data["descricao"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                subtitle: Text(
                  "${dataHora.day.toString().padLeft(2, '0')}/"
                  "${dataHora.month.toString().padLeft(2, '0')}/"
                  "${dataHora.year}  •  "
                  "${dataHora.hour.toString().padLeft(2, '0')}:"
                  "${dataHora.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.grey),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await controller.removerEvento(doc.id);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
