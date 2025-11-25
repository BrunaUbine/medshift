import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'services/stream_service.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final client = StreamService.client;

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MedShift',
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
