import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller/paginicialcontroller.dart';
import 'View/loginview.dart';
import 'View/pacientesview.dart';
import 'View/prontuariosview.dart';
import 'View/medicamentosview.dart';
import 'View/anotacoesview.dart';
import 'View/agendaview.dart';
import 'View/sobreview.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PagInicialController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MedShift',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F9FF), // azul claro sutil
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2), // azul medicina
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            labelStyle: const TextStyle(color: Color(0xFF1976D2)),
          ),
        ),
        // Tela inicial
        home: const LoginView(),

        // Rotas nomeadas para as demais telas
        routes: {
          '/pacientes': (context) => const PacientesView(),
          '/prontuario': (context) => const ProntuarioView(),
          '/medicamentos': (context) => const MedicamentosView(),
          '/anotacoes': (context) => const AnotacoesView(),
          '/agenda': (context) => const AgendaView(),
          '/sobre': (context) => const SobreView(),
        },
      ),
    );
  }
}
