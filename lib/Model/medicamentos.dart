import 'package:cloud_firestore/cloud_firestore.dart';

class Medicamento {
  final String id;
  final String nome;
  final String dose;
  final String horario;
  final String observacao;
  final DateTime criadoEm;

  Medicamento({
    required this.id,
    required this.nome,
    required this.dose,
    required this.horario,
    required this.observacao,
    required this.criadoEm,
  });

  factory Medicamento.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return Medicamento(
      id: doc.id,
      nome: data?['nome'] ?? '',
      dose: data?['dose'] ?? '',
      horario: data?['horario'] ?? '',
      observacao: data?['observacao'] ?? '',
      criadoEm: (data?['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'dose': dose,
      'horario': horario,
      'observacao': observacao,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }
}
