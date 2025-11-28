import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/medicamentosController.dart';

class MedicamentosView extends StatefulWidget {
  final String pacienteId;
  final String pacienteNome;

  const MedicamentosView({
    super.key,
    required this.pacienteId,
    required this.pacienteNome,
  });

  @override
  State<MedicamentosView> createState() => _MedicamentosViewState();
}

class _MedicamentosViewState extends State<MedicamentosView> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: Text(
          "Medicamentos — ${widget.pacienteNome}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Adicionar Medicamento",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.nomeCtl,
              decoration: InputDecoration(
                labelText: "Nome do Medicamento",
                prefixIcon: const Icon(Icons.medical_services_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.doseCtl,
              decoration: InputDecoration(
                labelText: "Dose",
                prefixIcon: const Icon(Icons.monitor_weight_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.horarioCtl,
              decoration: InputDecoration(
                labelText: "Horário",
                prefixIcon: const Icon(Icons.schedule),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller.obsCtl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Observação",
                prefixIcon: const Icon(Icons.description_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final erro =
                    await controller.salvarMedicamento(widget.pacienteId);

                if (erro != null && mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(erro)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Medicamento salvo!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
