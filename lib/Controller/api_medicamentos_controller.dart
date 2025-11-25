import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiMedicamentosController extends ChangeNotifier {
  final buscaController = TextEditingController();
  bool carregando = false;
  List<dynamic> resultados = [];

  Future<void> buscar() async {
    final termo = buscaController.text.trim();
    if (termo.isEmpty) return;

    carregando = true;
    resultados = [];
    notifyListeners();

    final url =
        'https://consultas.anvisa.gov.br/api/medicamento/produtos?descricao=${Uri.encodeQueryComponent(termo)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        resultados = jsonDecode(response.body) as List<dynamic>;
      } else {
        resultados = [];
      }
    } catch (e) {
      resultados = [];
    }

    carregando = false;
    notifyListeners();
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }
}
