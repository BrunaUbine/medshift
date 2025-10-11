import 'package:medshift/Controller/medicamentosController.dart';

import '../model/paciente.dart';
import '../model/entrada_paciente.dart';
import '../model/medicamentos.dart';
import '../model/anotacoes.dart';
import '../model/agenda.dart';

/// Simulação de um banco de dados em memória para testes e protótipos.
/// Todos os dados aqui são temporários e reiniciam a cada execução do app.
class BancoDeDadosSimulado {
  /// Lista de pacientes cadastrados
  static List<Paciente> pacientes = [
    Paciente(id: 1, nome: 'Maria Silva', telefone: '11988887777', acompanhante: 'Carlos Silva'),
    Paciente(id: 2, nome: 'João Pereira', telefone: '11977776666', acompanhante: 'Ana Pereira'),
  ];

  /// Lista de registros de prontuário (anotações médicas)
  static List<EntradaPaciente> prontuarios = [
    EntradaPaciente(
      id: 1,
      pacienteId: 1,
      titulo: 'Avaliação inicial',
      descricao: 'Paciente apresentou queixas de dor lombar e cansaço constante.',
      criadoEm: DateTime.now().subtract(const Duration(days: 2)),
    ),
    EntradaPaciente(
      id: 2,
      pacienteId: 1,
      titulo: 'Retorno clínico',
      descricao: 'Relatou melhora após fisioterapia. Mantido acompanhamento.',
      criadoEm: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  /// Lista de medicamentos cadastrados
  static List<Medicamento> medicamentos = [
    Medicamento(
      id: 1,
      idPaciente: 1,
      nome: 'Dipirona',
      dose: '500mg',
      horario: 'A cada 6 horas',
      observacao: 'Em caso de febre ou dor.',
    ),
    Medicamento(
      id: 2,
      idPaciente: 1,
      nome: 'Omeprazol',
      dose: '20mg',
      horario: '1x ao dia antes do café da manhã',
      observacao: 'Manter uso contínuo por 15 dias.',
    ),
    Medicamento(
      id: 3,
      idPaciente: 2,
      nome: 'Amoxicilina',
      dose: '500mg',
      horario: 'A cada 8 horas',
      observacao: 'Completar o ciclo de 7 dias.',
    ),
    Medicamento(
      id: 4,
      idPaciente: -1, // não vinculado a paciente
      nome: 'Paracetamol',
      dose: '750mg',
      horario: 'A cada 8 horas',
      observacao: 'Uso geral para dor e febre leve.',
    ),
  ];

  /// Lista de anotações gerais
  static List<Anotacao> anotacoes = [
    Anotacao(
      id: 1,
      criadoEm: DateTime.now().subtract(const Duration(days: 1)),
      texto: 'Verificar estoque de medicamentos antes do plantão.',
    ),
    Anotacao(
      id: 2,
      criadoEm: DateTime.now(),
      texto: 'Atualizar ficha de João Pereira após retorno clínico.',
    ),
  ];

  /// Lista de compromissos na agenda
  static List<Agenda> agenda = [
    Agenda(id: 1, dataHora: DateTime.now().add(const Duration(days: 1)), descricao: 'Consulta - Maria Silva'),
    Agenda(id: 2, dataHora: DateTime.now().add(const Duration(days: 3)), descricao: 'Reunião com equipe médica'),
  ];
}
