import 'package:flutter/material.dart';
import 'package:medshift/View/components/popup_menu.dart';
import 'package:provider/provider.dart';
import '../Controller/pacientesController.dart';
import '../View/tela_compartilhadaView.dart';

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
      backgroundColor: const Color(0xFFF6F3FA),
      appBar: AppBar(
        title: const Text(
          'Pacientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [
          buildPopupMenu(context),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _formCard(controller),
            const SizedBox(height: 25),
            _listaPacientes(controller),
          ],
        ),
      ),
    );
  }

  Widget _formCard(PacientesController controller) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextField(
                decoration: InputDecoration(
                  labelText: "Pesquisar paciente...",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (valor) {
                  controller.atualizarFiltro(valor);
                },
              ),
              SizedBox(height: 20),

              const Text(
                "Cadastrar Paciente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: controller.nomeCtl,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  prefixIcon:
                      Icon(Icons.person_outline, color: Color(0xFF1976D2)),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o nome" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.telefoneCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                  prefixIcon:
                      Icon(Icons.phone_outlined, color: Color(0xFF1976D2)),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: controller.acompanhanteCtl,
                decoration: const InputDecoration(
                  labelText: "Acompanhante",
                  prefixIcon:
                      Icon(Icons.people_alt_outlined, color: Color(0xFF1976D2)),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Salvar Paciente",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final erro = await controller.addPaciente();

                    if (!mounted) return;

                    if (erro != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(erro)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Paciente cadastrado!"),
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
    );
  }

  Widget _listaPacientes(PacientesController controller) {
    return StreamBuilder(
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

        final docs = snapshot.data!.docs.where((doc) {
        final nome = (doc["nome"] ?? "").toString().toLowerCase();
        return nome.contains(controller.filtro);
        }).toList();

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),

                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1976D2).withOpacity(0.15),
                  radius: 22,
                  child:
                      const Icon(Icons.person, color: Color(0xFF1976D2), size: 26),
                ),

                title: Text(
                  data["nome"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                subtitle: Text(
                  "Acompanhante: ${data["acompanhante"]?.isEmpty ?? true ? "-" : data["acompanhante"]}",
                  style: const TextStyle(color: Colors.grey),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final erro = await controller.removerPaciente(doc.id);
                    if (!mounted) return;

                    if (erro != null) {
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
                      builder: (_) => TelaCompartilhadaView(
                        pacienteId: doc.id,
                        pacienteNome: data["nome"],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
