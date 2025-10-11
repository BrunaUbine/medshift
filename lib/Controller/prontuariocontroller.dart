import 'package:flutter/material.dart';
import 'package:medshift/bancoDeDados/banco_de_dados_simulado.dart';
import 'package:medshift/model/entrada_paciente.dart';

class ProntuarioController {
  final tituloCtl = TextEditingController();
  final descricaoCtl = TextEditingController();

void adicionarAnotacao(int idPaciente, VoidCallback atualizarUI) {
    if (tituloCtl.text.trim().isEmpty || descricaoCtl.text.trim().isEmpty) return;

   
    final id = BancoDeDadosSimulado.prontuarios.isEmpty
        ? 1
        : BancoDeDadosSimulado.prontuarios
                .map((e) => e.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    final novaEntrada = EntradaPaciente(
      id: id,
      pacienteId: idPaciente,
      titulo: tituloCtl.text.trim(),
      descricao: descricaoCtl.text.trim(),
      criadoEm: DateTime.now(),
    );

    BancoDeDadosSimulado.prontuarios.add(novaEntrada);
    limparCampos();
    atualizarUI();
  }


  List<EntradaPaciente> listarPorPaciente(int idPaciente) {
    final listaFiltrada = BancoDeDadosSimulado.prontuarios
        .where((p) => p.pacienteId == idPaciente)
        .toList();
    listaFiltrada.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return listaFiltrada;
  }


  void limparCampos() {
    tituloCtl.clear();
    descricaoCtl.clear();
  }
}
