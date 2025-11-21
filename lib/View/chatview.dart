import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showConnectionStateTile: true,
      ),
      body: Column(
        children: [
          const Expanded(child: MessageListView()),
          const TypingIndicator(),
          const MessageInput(),
        ],
      ),
    );
  }
}
