import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnotacoesController extends ChangeNotifier {
  final textoCtl = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> addAnotacao() async {
    try {
      final texto = textoCtl.text.trim();

      if (texto.isEmpty) return "Digite uma anotação.";

      final uid = auth.currentUser!.uid;

      await db.collection("anotacoes").add({
        "texto": texto,
        "uidUsuario": uid,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      textoCtl.clear();
      notifyListeners();
      return null;

    } catch (e) {
      return "Erro ao salvar anotação: $e";
    }
  }

  Stream<QuerySnapshot> listarStream() {
    final uid = auth.currentUser!.uid;

    return db
        .collection("anotacoes")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("criadoEm", descending: true)
        .snapshots();
  }

  Future<String?> removerAnotacao(String id) async {
    try {
      await db.collection("anotacoes").doc(id).delete();
      return null;
    } catch (e) {
      return "Erro ao remover anotação: $e";
    }
  }
}
