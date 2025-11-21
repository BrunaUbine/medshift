
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamService {
  static final client = StreamChatClient(
    "6cdxsgzrkt2s",
    logLevel: Level.INFO,
  );

  static Future<void> conectarUsuario(String uid, String nome) async {
    await client.connectUser(
      User(
        id: uid,
        extraData: {"name": nome},
      ),
      client.devToken(uid).rawValue,
    );
  }
}
