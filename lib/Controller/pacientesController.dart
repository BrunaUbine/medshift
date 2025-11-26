import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/paciente.dart';
import 'package:flutter/material.dart';

class PacientesController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nomeCtl = TextEditingController();
  final telefoneCtl = TextEditingController();
  final acompanhanteCtl = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> addPaciente() async {
    
    try{
    final uid = auth.currentUser!.uid;

    final nome = nomeCtl.text.trim();
    final telefone = telefoneCtl.text.trim();
    final acompanhante = acompanhanteCtl.text.trim();

    if (nome.isEmpty) return 'Nome é obrigatório.';

    await db.collection("pacientes").add({
      "nome": nome,
      "telefone": telefone,
      "acompanhante": acompanhante,
      "uidUsuario": uid,
      "criadoEm": FieldValue.serverTimestamp(),
      "nomeLower": nome.toLowerCase(),
    });
    limparCampos();
    notifyListeners();
    return null;

    } catch (e) {
      return "Erro ao adicionar paciente: $e";
    }
  }


  void limparCampos() {
    nomeCtl.clear();
    telefoneCtl.clear();
    acompanhanteCtl.clear();
  }

 Stream<QuerySnapshot> listarPacientesStream() {
  final uid = auth.currentUser!.uid;

  return db
      .collection("pacientes")
      .where("uidUsuario", isEqualTo: uid)
      .orderBy("criadoEm", descending: false)
      .snapshots();
  }
  Future<List<Paciente>> listarPacientes() async {
    final uid = auth.currentUser!.uid;

    final snap = await db
        .collection("pacientes")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("nomeLower")
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return Paciente(
        id: doc.id.hashCode, // ou pode criar campo “id”
        nome: data["nome"],
        telefone: data["telefone"],
        acompanhante: data["acompanhante"],
      );
    }).toList();
  }

  Future<String?> removerPaciente(String docId) async {
    try {
      await db.collection("pacientes").doc(docId).delete();
      notifyListeners();
      return null;
    } catch (e) {
      return "Erro ao remover: $e";
    }
  }

  Future<String?> atualizarPaciente(String docId) async {
    try {
      await db.collection("pacientes").doc(docId).update({
        "nome": nomeCtl.text.trim(),
        "telefone": telefoneCtl.text.trim(),
        "acompanhante": acompanhanteCtl.text.trim(),
        "nomeLower": nomeCtl.text.trim().toLowerCase(),
      });
      limparCampos();
      notifyListeners();
      return null;
    } catch (e) {
      return "Erro ao atualizar: $e";
    }
  }
}
