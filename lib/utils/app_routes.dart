import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/logincontroller.dart';
import '../Controller/pacientesController.dart';
import '../Controller/prontuarioController.dart';
import '../Controller/agendaController.dart';
import '../Controller/paginicialcontroller.dart';

import '../View/loginview.dart';
import '../View/cadastroview.dart';
import '../View/paginicialview.dart';
import '../View/pacientesView.dart';
import '../View/prontuariosView.dart';
import '../View/agendaView.dart';
import '../View/sobreView.dart';
import '../View/medicos_view.dart';

class AppRoutes {
  static const login = '/login';
  static const cadastro = '/cadastro';
  static const inicio = '/inicio';

  static const pacientes = '/pacientes';
  static const prontuarios = '/prontuarios';
  static const agenda = '/agenda';
  static const sobre = '/sobre';
  static const medicos = '/medicos';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => ChangeNotifierProvider(
          create: (_) => LoginController(),
          child: const LoginView(),
        ),

    cadastro: (_) => const CadastroView(),

    inicio: (_) => ChangeNotifierProvider(
          create: (_) => PaginaInicialController(),
          child: const PaginaInicialView(),
        ),


    agenda: (_) => ChangeNotifierProvider(
          create: (_) => AgendaController(),
          child: const AgendaView(),
        ),

    sobre: (_) => const SobreView(),

    medicos: (_) => const MedicosView(),
  };
}
