import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/tempo_controller.dart';
import 'components/menu_tile.dart';

class PaginaInicialView extends StatefulWidget {
  const PaginaInicialView({super.key});

  @override
  State<PaginaInicialView> createState() => _PaginaInicialViewState();
}

class _PaginaInicialViewState extends State<PaginaInicialView> {
  @override
  void initState() {
    super.initState();
    Provider.of<TempoController>(context, listen: false).carregarHora();
  }

  @override
  Widget build(BuildContext context) {
    final tempo = Provider.of<TempoController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "MedShift",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// HORÁRIO CENTRALIZADO
            Center(
              child: Text(
                tempo.horaAtual.isEmpty ? "--:--" : tempo.horaAtual,
                style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// MENU
            MenuTile(
              icon: Icons.people,
              title: "Pacientes",
              onTap: () => Navigator.pushNamed(context, "/pacientes"),
            ),

            MenuTile(
              icon: Icons.calendar_month,
              title: "Agenda",
              onTap: () => Navigator.pushNamed(context, "/agenda"),
            ),

            MenuTile(
              icon: Icons.medical_services_outlined,
              title: "Médicos",
              onTap: () => Navigator.pushNamed(context, "/medicos"),
            ),

            MenuTile(
              icon: Icons.info_outline,
              title: "Sobre",
              onTap: () => Navigator.pushNamed(context, "/sobre"),
            ),

            MenuTile(
              icon: Icons.logout,
              title: "Sair",
              onTap: () => Navigator.pushNamed(context, "/login"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
