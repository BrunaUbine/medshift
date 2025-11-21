import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'services/stream_service.dart';
import 'View/loginview.dart';
import 'package:provider/provider.dart';
import 'Controller/logincontroller.dart';
import 'View/conversasView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final client = StreamService.client;

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginController()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginView(),
        ),
      ),
    );
  }
}
