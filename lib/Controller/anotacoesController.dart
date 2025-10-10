import '../bancoDeDados/banco_de_dados_simulado.dart';
import '../model/anotacoes.dart';
import 'package:flutter/material.dart';

class AnotacoesController {
  final textoCtl = TextEditingController();

  void addAnotacao(VoidCallback atualizarUI) {
    if (textoCtl.text.trim().isEmpty) return;

    final id = BancoDeDadosSimulado.anotacoes.isEmpty
        ? 1
        : BancoDeDadosSimulado.anotacoes.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final nova = Anotacao(
      id: id,
      criadoEm: DateTime.now(),
      texto: textoCtl.text.trim(),
    );

    BancoDeDadosSimulado.anotacoes.add(nova);
    textoCtl.clear();
    atualizarUI();
  }

  List<Anotacao> listarAnotacoes() {
    return List.from(BancoDeDadosSimulado.anotacoes.reversed);
  }
}
