  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'AppState.dart'; 
  import 'Controller/paginicialcontroller.dart';
  import 'View/loginview.dart';
  import 'View/pacientesview.dart';
  import 'View/prontuariosView.dart';
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
        ChangeNotifierProvider(create: (_) => AppState()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MedShift',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F9FF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2),
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

        home: const LoginView(),

        routes: {
          '/pacientes': (context) => const PacientesView(),
          '/prontuario': (context) => const ProntuariosView(),
          '/medicamentos': (context) => MedicamentosView(), 
          '/anotacoes': (context) => AnotacoesView(),
          '/agenda': (context) => AgendaView(),
          '/sobre': (context) => SobreView(),
        },
      ),
    );
  }
}