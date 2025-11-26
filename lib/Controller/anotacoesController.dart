import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/anotacoes.dart';
import 'package:flutter/material.dart';

class AnotacoesController extends ChangeNotifier{
  final textoCtl = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> addAnotacao() async {
    try {
      final texto = textoCtl.text.trim();
      if (texto.isEmpty) return "A anotação não pode ser vazia.";

      final uid = auth.currentUser!.uid;

      await db.collection("anotacoes").add({
        "texto": texto,
        "uidUsuario": uid,
        "criadoEm": FieldValue.serverTimestamp(),
      });
      textoCtl.clear();
      notifyListeners();
      return null; // sucesso

    } catch (e) {
      return "Erro ao salvar anotação: $e";
    }
  }

  Stream<QuerySnapshot> listarAnotacoesStream() {
    final uid = auth.currentUser!.uid;

    return db
        .collection("anotacoes")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("criadoEm", descending: true)
        .snapshots();
  }

 Future<List<Anotacao>> listarAnotacoes() async {
    final uid = auth.currentUser!.uid;

    final snap = await db
        .collection("anotacoes")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("criadoEm", descending: true)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();

      return Anotacao(
        id: doc.id.hashCode,
        texto: data["texto"],
        criadoEm: (data["criadoEm"] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }
  Future<String?> removerAnotacao(String id) async {
    try {
      await db.collection("anotacoes").doc(id).delete();
      return null;
    } catch (e) {
      return "Erro ao remover anotação: $e";
    }
  }
 void limparCampos() {
    textoCtl.clear();
  }
}
