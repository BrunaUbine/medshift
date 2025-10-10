import '../model/paciente.dart';
import '../model/entrada_paciente.dart';
import '../model/medicamentos.dart';
import '../model/anotacoes.dart';
import '../model/agenda.dart';

class BancoDeDadosSimulado {
  
  static final List<Paciente> pacientes = [];
  static final List<Entrada_paciente> prontuarios = []; 
  static final List<Medicamento> medicamentos = [];
  static final List<Anotacao> anotacoes = [];
  static final List<Agenda> agenda = [];

  
  static Paciente? selecionePorIdPaciente(int id) {
    try {
      return pacientes.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
