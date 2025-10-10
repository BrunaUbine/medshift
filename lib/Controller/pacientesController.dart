import '../bancoDeDados/banco_de_dados_simulado.dart';
import '../model/paciente.dart';
import 'package:flutter/material.dart';

class PacientesController {
  final formKey = GlobalKey<FormState>();
  final nomeCtl = TextEditingController();
  final telefoneCtl = TextEditingController();
  final acompanhanteCtl = TextEditingController();

  void addPaciente(VoidCallback atualizarUI) {
    final nome = nomeCtl.text.trim();
    if (nome.isEmpty) return;

    final id = BancoDeDadosSimulado().pacientes.isEmpty
        ? 1
        : BancoDeDadosSimulado().pacientes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final novo = Paciente(
      id: id,
      nome: nome,
      telefone: telefoneCtl.text.trim(),
      acompanhante: acompanhanteCtl.text.trim(),
    );

    BancoDeDadosSimulado.pacientes.add(novo);

    limparCampos();
    atualizarUI();
  }

  void limparCampos() {
    nomeCtl.clear();
    telefoneCtl.clear();
    acompanhanteCtl.clear();
  }

  List<Paciente> listarPacientes() {
    return List.from(BancoDeDadosSimulado().pacientes);
  }

  void removerPaciente(int id, VoidCallback atualizarUI) {
    BancoDeDadosSimulado.pacientes.removeWhere((p) => p.id == id);
    atualizarUI();
  }
}
