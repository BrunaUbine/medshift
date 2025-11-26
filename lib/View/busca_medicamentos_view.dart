import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/medicamentosController.dart';

class BuscaMedicamentosView extends StatefulWidget {
  const BuscaMedicamentosView({super.key});

  @override
  State<BuscaMedicamentosView> createState() => _BuscaMedicamentosViewState();
}

class _BuscaMedicamentosViewState extends State<BuscaMedicamentosView> {
  List<String> resultados = [];
  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MedicamentosController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A3D62),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text("Buscar Medicamento"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Digite o nome...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1C3D5A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (texto) async {
                if (texto.length < 3) return;

                setState(() => carregando = true);

                resultados = await controller.buscarMedicamentos(texto);

                setState(() => carregando = false);
              },
            ),
          ),

          if (carregando)
            const CircularProgressIndicator(color: Colors.white),

          Expanded(
            child: ListView(
              children: resultados.map((item) {
                return ListTile(
                  title: Text(item, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
