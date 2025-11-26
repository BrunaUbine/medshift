import 'package:flutter/material.dart';
import 'package:medshift/Controller/medicamentosController.dart';
import 'package:medshift/Controller/pacientesController.dart';
import 'package:medshift/Controller/prontuariocontroller.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';
import 'package:medshift/View/components/popup_menu.dart';
import 'package:provider/provider.dart';

class PacientesView extends StatefulWidget {
  const PacientesView({super.key});

  @override
  State<PacientesView> createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PacientesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pacientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Cadastrar Paciente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1976D2),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: controller.nomeCtl,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Informe o nome" : null,
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: controller.telefoneCtl,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: controller.acompanhanteCtl,
                        decoration: const InputDecoration(
                          labelText: 'Acompanhante',
                          prefixIcon: Icon(Icons.people_alt_outlined),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Salvar Paciente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final erro = await controller.addPaciente();

                            if (erro != null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(erro)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Paciente cadastrado!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),

            const Text(
              'Pacientes Cadastrados',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 10),

            StreamBuilder(
              stream: controller.listarPacientesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "Nenhum paciente cadastrado.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Color(0xFF1976D2),
                        ),

                        title: Text(
                          data["nome"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: Text(
                          "Acompanhante: ${data["acompanhante"]?.isEmpty ?? true ? "-" : data["acompanhante"]}",
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            final erro = await controller.removerPaciente(doc.id);
                            if (erro != null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(erro)),
                              );
                            }
                          },
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(create: (_) => ProntuarioController()),
                                  ChangeNotifierProvider(create: (_) => MedicamentosController()),
                                ],
                                child: TelaCompartilhadaView(
                                  pacienteId: doc.id,
                                  pacienteNome: data["nome"],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
