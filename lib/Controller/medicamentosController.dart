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

  Future<List<String>> buscarMedicamentos(String texto) async {
  try {
    if (texto.isEmpty) return [];

    carregandoAPI = true;
    notifyListeners();

    final url =
        "https://api.fda.gov/drug/label.json?search=openfda.brand_name:$texto&limit=20";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["results"] != null) {
        sugestoes = [];

        for (var item in data["results"]) {
          if (item["openfda"] != null) {
            final names = item["openfda"]["brand_name"];

            if (names is List && names.isNotEmpty) {
              sugestoes.add(names.first.toString());
            }
          }
        }
        if (sugestoes.isEmpty) {
          sugestoes = ["Nenhum medicamento encontrado"];
        }
      } else {
        sugestoes = ["Nenhum resultado encontrado"];
      }
    } else {
      sugestoes = ["Erro na API (${response.statusCode})"];
    }
  } catch (e) {
    sugestoes = ["Erro inesperado"];
  }

  carregandoAPI = false;
  notifyListeners();
  return sugestoes;
}

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
        .orderBy("criadoEm", descending: true)
        .snapshots();
  }

  void limparCampos() {
    nomeCtl.clear();
    doseCtl.clear();
    horarioCtl.clear();
    obsCtl.clear();
  }
}
