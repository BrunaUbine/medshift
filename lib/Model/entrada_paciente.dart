class EntradaPaciente {
  final int id;
  final int pacienteId;
  final String titulo;
  final String descricao;
  final DateTime criadoEm;

  EntradaPaciente({
    required this.id,
    required this.pacienteId,
    required this.titulo,
    required this.descricao,
    required this.criadoEm,
  });
}
