import 'package:flutter/material.dart';
import 'package:medshift/Controller/paginicialcontroller.dart';
import 'package:provider/provider.dart';

class PaginaInicialView extends StatelessWidget {
  const PaginaInicialView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PagInicialController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MedShift - Início",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: controller.funcionalidades.length,
        itemBuilder: (context, index) {
          final funcionalidade = controller.funcionalidades[index];
          final iconData = controller.getIconFor(funcionalidade);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),

              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
                child: Icon(
                  iconData,
                  color: const Color(0xFF1976D2),
                ),
              ),

              title: Text(
                funcionalidade,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey,
              ),

              onTap: () => controller.aoClicar(context, funcionalidade),
            ),
          );
        },
      ),
    );
  }
}
