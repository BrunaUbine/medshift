import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/logincontroller.dart';
import '../Controller/pacientesController.dart';
import '../Controller/prontuarioController.dart';
import '../Controller/agendaController.dart';
import '../Controller/anotacoesController.dart';
import '../Controller/medicamentosController.dart';
import '../Controller/paginicialcontroller.dart';

import '../View/loginview.dart';
import '../View/cadastroview.dart';
import '../View/paginicialview.dart';
import '../View/pacientesView.dart';
import '../View/prontuariosView.dart';
import '../View/agendaView.dart';
import '../View/anotacoesView.dart';
import '../View/medicamentosView.dart';
import '../View/sobreView.dart';

class AppRoutes {
  static const login = '/login';
  static const cadastro = '/cadastro';
  static const inicio = '/inicio';

  static const pacientes = '/pacientes';
  static const prontuarios = '/prontuarios';
  static const medicamentos = '/medicamentos';
  static const anotacoes = '/anotacoes';
  static const agenda = '/agenda';
  static const sobre = '/sobre';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => ChangeNotifierProvider(
          create: (_) => LoginController(),
          child: const LoginView(),
        ),

    cadastro: (_) => const Cadastroview(),

    inicio: (_) => ChangeNotifierProvider(
          create: (_) => PaginaInicialController(),
          child: const PaginaInicialView(),
        ),

    pacientes: (_) => ChangeNotifierProvider(
          create: (_) => PacientesController(),
          child: const PacientesView(),
        ),

    prontuarios: (_) => ChangeNotifierProvider(
          create: (_) => ProntuarioController(),
          child: const ProntuariosView(),
        ),

    medicamentos: (_) => ChangeNotifierProvider(
          create: (_) => MedicamentosController(),
          child: const MedicamentosView(),
        ),

    anotacoes: (_) => ChangeNotifierProvider(
          create: (_) => AnotacoesController(),
          child: const AnotacoesView(),
        ),

    agenda: (_) => ChangeNotifierProvider(
          create: (_) => AgendaController(),
          child: const AgendaView(),
        ),

    sobre: (_) => const SobreView(),
  };
}
