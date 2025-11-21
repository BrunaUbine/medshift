import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicamentosController extends ChangeNotifier {
  final nomeCtl = TextEditingController();
  final doseCtl = TextEditingController();
  final horarioCtl = TextEditingController();
  final obsCtl = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> adicionarMedicamento(String pacienteId) async {
    try {
      if (nomeCtl.text.trim().isEmpty) {
        return "O nome é obrigatório.";
      }

      final uid = auth.currentUser!.uid;

      await db.collection("medicamentos").add({
        "pacienteId": pacienteId,
        "nome": nomeCtl.text.trim(),
        "dose": doseCtl.text.trim(),
        "horario": horarioCtl.text.trim(),
        "observacao": obsCtl.text.trim(),
        "uidUsuario": uid,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      limparCampos();
      return null;

    } catch (e) {
      return "Erro ao adicionar medicamento: $e";
    }
  }

  Stream<QuerySnapshot> listarPorPacienteStream(String pacienteId) {
    final uid = auth.currentUser!.uid;

    return db
        .collection("medicamentos")
        .where("uidUsuario", isEqualTo: uid)
        .where("pacienteId", isEqualTo: pacienteId)
        .orderBy("criadoEm", descending: true)
        .snapshots();
  }

  Future<String?> removerMedicamento(String id) async {
    try {
      await db.collection("medicamentos").doc(id).delete();
      return null;
    } catch (e) {
      return "Erro ao remover medicamento: $e";
    }
  }

  void limparCampos() {
    nomeCtl.clear();
    doseCtl.clear();
    horarioCtl.clear();
    obsCtl.clear();
  }
}
