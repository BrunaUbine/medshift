import '../bancoDeDados/banco_de_dados_simulado.dart';
import '../model/agenda.dart';
import 'package:flutter/material.dart';

class AgendaController {
  final descCtl = TextEditingController();
  DateTime? dataSelecionada;

  void selecionarData(BuildContext context, VoidCallback atualizarUI) async {
    final now = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (data == null) return;
    final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (hora == null) return;

    dataSelecionada = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
    atualizarUI();
  }

  void adicionarEvento(VoidCallback atualizarUI) {
    if (descCtl.text.trim().isEmpty || dataSelecionada == null) return;

    final id = BancoDeDadosSimulado.agenda.isEmpty
        ? 1
        : BancoDeDadosSimulado.agenda.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    final novo = Agenda(id: id, dataHora: dataSelecionada!, descricao: descCtl.text.trim());
    BancoDeDadosSimulado.agenda.add(novo);

    descCtl.clear();
    dataSelecionada = null;
    atualizarUI();
  }

  List<Agenda> listarEventos() {
    final eventos = List.from(BancoDeDadosSimulado.agenda);
    eventos.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    return eventos;
  }
}
