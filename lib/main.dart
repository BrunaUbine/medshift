import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/app_routes.dart';

import 'Controller/logincontroller.dart';
import 'Controller/pacientesController.dart';
import 'Controller/prontuarioController.dart';
import 'Controller/agendaController.dart';
import 'Controller/anotacoesController.dart';
import 'Controller/medicamentosController.dart';
import 'Controller/paginicialcontroller.dart';
import 'Controller/tempo_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => PacientesController()),
        ChangeNotifierProvider(create: (_) => ProntuarioController()),
        ChangeNotifierProvider(create: (_) => MedicamentosController()),
        ChangeNotifierProvider(create: (_) => AgendaController()),
        ChangeNotifierProvider(create: (_) => AnotacoesController()),
        ChangeNotifierProvider(create: (_) => PaginaInicialController()),
        ChangeNotifierProvider(create: (_) => TempoController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        routes: AppRoutes.routes,

        initialRoute: AppRoutes.login,

        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF6F3FA),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            floatingLabelStyle: const TextStyle(
              color: Color(0xFF1976D2),
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
