import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: stream.StreamChannelHeader(),
      body: Column(
        children: const [
          Expanded(child: stream.StreamMessageListView()),
          stream.StreamMessageInput(),
        ],
      ),
    );
  }
}
