import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicamentosController extends ChangeNotifier {
  final nomeCtl = TextEditingController();
  final doseCtl = TextEditingController();
  final horarioCtl = TextEditingController();
  final obsCtl = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool carregandoAPI = false;
  List<String> sugestoes = [];

  Future<String?> salvarMedicamento(String pacienteId) async {
    try {
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
      return "Erro ao salvar: $e";
    }
  }

  Stream<QuerySnapshot> historico(String pacienteId) {
    final uid = auth.currentUser!.uid;

    return db
        .collection("medicamentos")
        .where("uidUsuario", isEqualTo: uid)
        .where("pacienteId", isEqualTo: pacienteId)
        .snapshots();
  }

  void limparCampos() {
    nomeCtl.clear();
    doseCtl.clear();
    horarioCtl.clear();
    obsCtl.clear();
  }
}
