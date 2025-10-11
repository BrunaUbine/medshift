import 'package:flutter/material.dart';
import 'package:medshift/Controller/paginicialcontroller.dart';
import 'package:provider/provider.dart';

class PaginaInicialView extends StatelessWidget {
  const PaginaInicialView({super.key});

  @override
  Widget build (BuildContext context) {
    final controller = Provider.of<PagInicialController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MedShift - Início"),
        backgroundColor: const Color(0xFF1976D2), 
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: controller.funcionalidades.length,
        itemBuilder: (context, index){
          final funcionalidade = controller.funcionalidades[index];      

          final iconData = controller.getIconFor(funcionalidade);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(

              leading: Icon(
                iconData, 
                color: const Color(0xFF1976D2),
                size: 30,
              ),
              title: Text(
                funcionalidade,
                style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1976D2)),
              ),
   
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () => controller.aoClicar(context, funcionalidade),
            ),
          );
        },
      ),
    );
  }
}
