import 'package:meuapppdv/model/medicamentos.dart';
import '../bancoDeDados/banco_de_dados_simulado.dart';
import 'package:flutter/material.dart';

class MedicamentosController {
  final nomeCtl = TextEditingController();
  final doseCtl = TextEditingController();
  final horarioCtl = TextEditingController();
  final obsCtl = TextEditingController();

  void adicionarMedicamento(int idPaciente, VoidCallback atualizarUI) {
    if (nomeCtl.text.trim().isEmpty) return;

    final id = BancoDeDadosSimulado.medicamentos.isEmpty
        ? 1
        : BancoDeDadosSimulado.medicamentos.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final novo = Medicamento(
      id: id,
      idPaciente: idPaciente,
      nome: nomeCtl.text.trim(),
      dose: doseCtl.text.trim(),
      horario: horarioCtl.text.trim(),
      observacao: obsCtl.text.trim(),
    );

    BancoDeDadosSimulado.medicamentos.add(novo);
    limparCampos();
    atualizarUI();
  }

  List<Medicamento> listarTodos() {
    return List.from(BancoDeDadosSimulado.medicamentos.reversed);
  }

  void limparCampos() {
    nomeCtl.clear();
    doseCtl.clear();
    horarioCtl.clear();
    obsCtl.clear();
  }
}
