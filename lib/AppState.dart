import 'package:flutter/material.dart';
import 'bancoDeDados/banco_de_dados_simulado.dart';
import 'model/paciente.dart';

/// Classe base do estado global da aplicação
class AppState extends ChangeNotifier {
  List<Paciente> get pacientes => BancoDeDadosSimulado.pacientes;

  void atualizarPacientes() {
    notifyListeners();
  }
}

/// Widget que provê o estado global (AppState) para todo o app
class AppStateWidget extends InheritedWidget {
  final AppState state;

  const AppStateWidget({
    super.key,
    required this.state,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    assert(widget != null, 'Nenhum AppStateWidget encontrado no contexto');
    return widget!.state;
  }

  static AppState? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    return widget?.state;
  }

  @override
  bool updateShouldNotify(covariant AppStateWidget oldWidget) =>
      oldWidget.state != state;
}
