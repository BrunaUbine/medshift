import 'package:meuapppdv/Model/entrada_paciente.dart';
import 'package:meuapppdv/bancoDeDados/banco_de_dados_simulado.dart';
import 'package:meuapppdv/Controller/pacientesController.dart';
import 'package:flutter/material.dart';

class ProntuarioController {
  final tituloCtl = TextEditingController();
  final descricaoCtl = TextEditingController();

  void adicionarAnotacao(int idPaciente, VoidCallback atualizarUI) {
    if (tituloCtl.text.trim().isEmpty || descricaoCtl.text.trim().isEmpty) return;

    final id = BancoDeDadosSimulado().prontuarios.isEmpty
        ? 1
        : BancoDeDadosSimulado.prontuarios.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final novo = Entrada_paciente(
      id: id,
      idPaciente: idPaciente,
      criadoEm: DateTime.now(),
      titulo: tituloCtl.text.trim(),
      descricao: descricaoCtl.text.trim(),
    );

    BancoDeDadosSimulado.prontuarios.add(novo);
    limparCampos();
    atualizarUI();
  }

  List<Entrada_paciente> listarPorPaciente(int isPaciente) {
    return BancoDeDadosSimulado.prontuarios
        .where((p) => p.idPaciente == idPaciente)
        .toList()
      ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
  }

  void limparCampos() {
    tituloCtl.clear();
    descricaoCtl.clear();
  }
}
