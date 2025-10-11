import 'package:flutter/material.dart';
import 'package:medshift/Controller/pacientesController.dart';
import '../bancoDeDados/banco_de_dados_simulado.dart';
import 'package:medshift/View/tela_compartilhadaView.dart';

class PacientesView extends StatefulWidget {
  const PacientesView({super.key});

  @override
  State<PacientesView> createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  final controller = PacientesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pacientes'),
        actions: [
          buildPopupMenu(context),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🩺 Card de cadastro
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                    TextField(
                      controller: controller.nomeCtl,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.telefoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.acompanhanteCtl,
                      decoration: const InputDecoration(
                        labelText: 'Acompanhante',
                        prefixIcon: Icon(Icons.people_alt_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt),
                        label: const Text(
                          'Salvar Paciente',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => setState(() {
                          controller.addPaciente(() => setState(() {}));
                        }),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),

            // 👥 Lista de pacientes
            const Text(
              'Pacientes Cadastrados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            if (BancoDeDadosSimulado.pacientes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Nenhum paciente cadastrado ainda.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: BancoDeDadosSimulado.pacientes.map((p) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF1976D2)),
                      title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Acompanhante: ${p.acompanhante.isEmpty ? '-' : p.acompanhante}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => setState(() {
                          controller.removerPaciente(p.id, () => setState(() {}));
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
