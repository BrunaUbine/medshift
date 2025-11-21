import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../services/stream_service.dart';

class LoginController extends ChangeNotifier {
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool carregando = false;
  void setLoading(bool v) {
    carregando = v;
    notifyListeners();
  }

  Future<void> conectarStream(User user) async {
    final client = StreamService.client;

    await client.connectUser(
      User(
        id: user.uid,
        extraData: {
          "name": user.displayName ?? user.email!,
        },
      ),
      client.devToken(user.uid).rawValue,
    );
  }

  Future<String?> login(BuildContext context) async {
    try {
      setLoading(true);

      final cred = await auth.signInWithEmailAndPassword(
        email: txtEmail.text.trim(),
        password: txtSenha.text.trim(),
      );

      final user = cred.user!;
      await conectarStream(user);

      setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    }
  }

  void limpar() {
    txtEmail.clear();
    txtSenha.clear();
  }
}
