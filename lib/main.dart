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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
