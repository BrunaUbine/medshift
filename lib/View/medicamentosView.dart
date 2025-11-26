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
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool mostrandoSugestoes = false;

  void mostrarSugestoes() {
    if (_overlayEntry != null) return;

    final controller = Provider.of<MedicamentosController>(context, listen: false);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 55),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                if (controller.sugestoes.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: controller.sugestoes.map((item) {
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        controller.nomeCtl.text = item;
                        esconderSugestoes();
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void esconderSugestoes() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: Text("Medicamentos — ${widget.pacienteNome}"),
      ),
      body: GestureDetector(
        onTap: esconderSugestoes,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Adicionar Medicamento",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: controller.nomeCtl,
                  decoration: InputDecoration(
                    labelText: "Nome do Medicamento",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (texto) async {
                    if (texto.length < 2) {
                      controller.sugestoes = [];
                      esconderSugestoes();
                      return;
                    }

                    await controller.buscarMedicamentos(texto);

                    if (controller.sugestoes.isNotEmpty) {
                      mostrarSugestoes();
                    } else {
                      esconderSugestoes();
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller.doseCtl,
                decoration: const InputDecoration(
                  labelText: "Dose",
                  prefixIcon: Icon(Icons.medical_information),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller.horarioCtl,
                decoration: const InputDecoration(
                  labelText: "Horário",
                  prefixIcon: Icon(Icons.schedule),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller.obsCtl,
                decoration: const InputDecoration(
                  labelText: "Observação",
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final erro = await controller.salvarMedicamento(widget.pacienteId);

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
                child: const Text("Salvar", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
