import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meuapppdv/Controller/paginicialController.dart';


class paginaInicialView extends StatelessWidget{
  const paginaInicialView({super.key});
  @override
  Widget build (BuildContext context) {
    final controller = Provider.of<paginaInicialController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("medshift - Inicio")
      ),
      body: ListView.builder(
        itemCount: controller.funcionalidades.length,
        itemBuilder: (context, index){
          final funcionalidade = controller.funcionalidades[index];
          return ListTile(
            title: Text(funcionalidade),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => controller.aoClicar(context,  funcionalidade),
          );
        },
      ),
    );
  }
}



