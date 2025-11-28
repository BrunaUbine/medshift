import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProntuarioController extends ChangeNotifier {
  final tituloCtl = TextEditingController();
  final descricaoCtl = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> adicionarAnotacao(String pacienteId) async {
    try {
      final uid = auth.currentUser!.uid;

      final titulo = tituloCtl.text.trim();
      final descricao = descricaoCtl.text.trim();

      if (titulo.isEmpty || descricao.isEmpty) {
        return "Preencha título e descrição.";
      }

      await db.collection("prontuarios").add({
        "pacienteId": pacienteId,
        "titulo": titulo,
        "descricao": descricao,
        "uidUsuario": uid,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      limparCampos();
      return null;

    } catch (e) {
      return "Erro ao adicionar anotação: $e";
    }
  }

  Stream<QuerySnapshot> listarPorPacienteStream(String pacienteId) {
    final uid = auth.currentUser!.uid;

    return db
        .collection("prontuarios")
        .where("uidUsuario", isEqualTo: uid)
        .where("pacienteId", isEqualTo: pacienteId)
        .snapshots();
  }

  Future<String?> removerAnotacao(String docId) async {
    try {
      await db.collection("prontuarios").doc(docId).delete();
      return null;
    } catch (e) {
      return "Erro ao remover anotação: $e";
    }
  }

  void limparCampos() {
    tituloCtl.clear();
    descricaoCtl.clear();
  }
}
