import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TempoController extends ChangeNotifier {
  String horaAtual = "";

  Future<void> carregarHora() async {
    try {
      final url = Uri.parse(
        "https://worldtimeapi.org/api/timezone/America/Sao_Paulo"
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String datetimeStr = data["datetime"];
        String offsetStr = data["utc_offset"]; // ex: "-03:00"

        DateTime datetime = DateTime.parse(datetimeStr);

        final offsetHours = int.parse(offsetStr.substring(1, 3));
        final offsetMinutes = int.parse(offsetStr.substring(4, 6));

        if (offsetStr.startsWith("-")) {
          datetime = datetime.subtract(
            Duration(hours: offsetHours, minutes: offsetMinutes),
          );
        } else {
          datetime = datetime.add(
            Duration(hours: offsetHours, minutes: offsetMinutes),
          );
        }

        final hora = datetime.hour.toString().padLeft(2, '0');
        final min = datetime.minute.toString().padLeft(2, '0');

        horaAtual = "$hora:$min";
      } else {
        horaAtual = "--:--";
      }
    } catch (e) {
      horaAtual = "--:--";
    }

    notifyListeners();
  }
}
