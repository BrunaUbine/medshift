class Medicamento {
  final int id;
  final int idPaciente; // opcional;  -1 se não vinculado
  final String nome;
  final String dose;
  final String horario;
  final String observacao;

  Medicamento({
    required this.id,
    required this.idPaciente,
    required this.nome,
    required this.dose,
    required this.horario,
    required this.observacao,
  });
}
