import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiChatService {
  static const String apiUrl = "https://sua-api-aqui.com/chat"; // TROCAR!

  static Future<String> enviarMensagem(String texto) async {
    try {
      final resposta = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "mensagem": texto,
        }),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        return dados["resposta"] ?? "Sem resposta da API.";
      } else {
        return "Erro ao contatar API (${resposta.statusCode})";
      }
    } catch (e) {
      return "Erro de conexão: $e";
    }
  }
}
