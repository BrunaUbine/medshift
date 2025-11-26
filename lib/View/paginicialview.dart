import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/paginicialcontroller.dart';

class PaginaInicialView extends StatelessWidget {
  const PaginaInicialView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PaginaInicialController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MedShift",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: controller.funcionalidades.length,
        itemBuilder: (context, index) {
          final funcionalidade = controller.funcionalidades[index];
          final icon = controller.getIconFor(funcionalidade);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: const Color(0xFF1976D2)),
              ),
              title: Text(
                funcionalidade,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => controller.aoClicar(context, funcionalidade),
            ),
          );
        },
      ),
    );
  }
}
