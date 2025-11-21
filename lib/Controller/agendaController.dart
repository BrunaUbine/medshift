import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/agenda.dart';
import 'package:flutter/material.dart';

class AgendaController extends ChangeNotifier {
  final descCtl = TextEditingController();
  DateTime? dataSelecionada;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> selecionarData(BuildContext context) async {
    final now = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (data == null) return;
    final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (hora == null) return;

    dataSelecionada = DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
  }

  Future<String?> adicionarEvento() async {
    try {
      final descricao = descCtl.text.trim();
      if (descricao.isEmpty) return "A descrição é obrigatória.";
      if (dataSelecionada == null) return "Selecione uma data e hora.";

      final uid = auth.currentUser!.uid;

      await db.collection("agenda").add({
        "descricao": descricao,
        "dataHora": Timestamp.fromDate(dataSelecionada!),
        "uidUsuario": uid,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      descCtl.clear();
      dataSelecionada = null;
      notifyListeners();

      return null;
  } catch (e) {
      return "Erro ao adicionar evento: $e";
    }
  }


  Stream<QuerySnapshot> listarEventosStream() {
    final uid = auth.currentUser!.uid;

    return db
        .collection("agenda")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("dataHora", descending: false)
        .snapshots();
  }
   Future<List<Agenda>> listarEventos() async {
    final uid = auth.currentUser!.uid;

    final snap = await db
        .collection("agenda")
        .where("uidUsuario", isEqualTo: uid)
        .orderBy("dataHora", descending: false)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return Agenda(
        id: doc.id.hashCode,
        descricao: data["descricao"],
        dataHora: (data["dataHora"] as Timestamp).toDate(),
      );
    }).toList();
  }
  Future<String?> removerEvento(String id) async {
    try {
      await db.collection("agenda").doc(id).delete();
      return null;
    } catch (e) {
      return "Erro ao remover evento: $e";
    }
  }
}

