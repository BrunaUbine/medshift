import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:medshift/Model/medicamentos.dart';

class MedicamentosController extends ChangeNotifier {
  final nomeCtl = TextEditingController();
  final doseCtl = TextEditingController();
  final horarioCtl = TextEditingController();
  final obsCtl = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> adicionarMedicamento(String pacienteId) async {
    try {
      final nome = nomeCtl.text.trim();
      final dose = doseCtl.text.trim();
      final horario = horarioCtl.text.trim();
      final observacao = obsCtl.text.trim();

      if (nome.isEmpty) return "O nome é obrigatório.";
      if (pacienteId.isEmpty) return "Paciente inválido.";

      final uid = auth.currentUser!.uid;

      await db.collection('medicamentos').add({
        'pacienteId': pacienteId,
        'nome': nome,
        'dose': dose,
        'horario': horario,
        'observacao': observacao,
        'uidUsuario': uid,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      limparCampos();
      notifyListeners();
      return null;
    } catch (e) {
      return 'Erro ao adicionar medicamento: $e';
    }
  }

  Stream<QuerySnapshot> listarPorPacienteStream(String pacienteId) {
    final uid = auth.currentUser!.uid;

    return db
        .collection('medicamentos')
        .where('uidUsuario', isEqualTo: uid)
        .where('pacienteId', isEqualTo: pacienteId)
        .orderBy('criadoEm', descending: true)
        .snapshots();
  }

  Future<String?> removerMedicamento(String id) async {
    try {
      await db.collection('medicamentos').doc(id).delete();
      return null;
    } catch (e) {
      return 'Erro ao remover medicamento: $e';
    }
  }

  Stream<List<Medicamento>> historicoMedicamentos(String pacienteId) {
    final uid = auth.currentUser!.uid;

    return db
        .collection('medicamentos')
        .where('uidUsuario', isEqualTo: uid)
        .where('pacienteId', isEqualTo: pacienteId)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Medicamento.fromFirestore(doc)).toList();
    });
  }

  void limparCampos() {
    nomeCtl.clear();
    doseCtl.clear();
    horarioCtl.clear();
    obsCtl.clear();
  }

  @override
  void dispose() {
    nomeCtl.dispose();
    doseCtl.dispose();
    horarioCtl.dispose();
    obsCtl.dispose();
    super.dispose();
  }
}
