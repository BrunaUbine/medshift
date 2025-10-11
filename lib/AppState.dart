import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:medshift/bancoDeDados/banco_de_dados_simulado.dart';
import '../model/paciente.dart';
import '../model/entrada_paciente.dart';
import '../model/medicamentos.dart';
import '../model/anotacoes.dart';
import '../model/agenda.dart';

class AppState extends ChangeNotifier {
  
  List<Paciente> get pacientes => BancoDeDadosSimulado.pacientes;
  List<EntradaPaciente> get prontuarios => BancoDeDadosSimulado.prontuarios;
  List<Medicamento> get medicamentos => BancoDeDadosSimulado.medicamentos;
  List<Anotacao> get anotacoes => BancoDeDadosSimulado.anotacoes;
  List<Agenda> get agenda => BancoDeDadosSimulado.agenda;

  void addPaciente(String nome, String telefone, String acompanhante) {
    final id = pacientes.isEmpty ? 1 : pacientes.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
    final p = Paciente(id: id, nome: nome, telefone: telefone, acompanhante: acompanhante);
    pacientes.add(p);
    notifyListeners();
  }

  void addEntradaPaciente(int idPaciente, String titulo, String descricao) {
    final id = prontuarios.isEmpty ? 1 : prontuarios.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final e = EntradaPaciente(id: id, pacienteId: idPaciente, criadoEm: DateTime.now(), titulo: titulo, descricao: descricao);
    prontuarios.add(e);
    notifyListeners();
  }

  void addMedicamento(int idPaciente, String nome, String dose, String horario, String observacao) {
    final id = medicamentos.isEmpty ? 1 : medicamentos.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
    final m = Medicamento(id: id, idPaciente: idPaciente, nome: nome, dose: dose, horario: horario, observacao: observacao);
    medicamentos.add(m);
    notifyListeners();
  }

  void addAnotacao(String texto) {
    final id = anotacoes.isEmpty ? 1 : anotacoes.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
    final an = Anotacao(id: id, criadoEm: DateTime.now(), texto: texto);
    anotacoes.add(an);
    notifyListeners();
  }

  void addAgenda(DateTime dataHora, String descricao) {
    final id = agenda.isEmpty ? 1 : agenda.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final ev = Agenda(id: id, dataHora: dataHora, descricao: descricao);
    agenda.add(ev);
    notifyListeners();
  }
}

/// InheritedNotifier para disponibilizar AppState no app (simples)
class AppStateWidget extends InheritedNotifier<AppState> {
  AppStateWidget({super.key, required super.child})
      : super(notifier: AppState());

  static AppState of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>()!;
    return widget.notifier!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<AppState> oldWidget) => true;
}
