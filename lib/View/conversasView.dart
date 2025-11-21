import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../Controller/logincontroller.dart';
import '../View/lista_usuarioView.dart';
import '../View/chatview.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final userId = client.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversas"),
        backgroundColor: const Color(0xFF1976D2),
      ),

      body: ChannelListView(
        filter: Filter.in_('members', [userId]),

        sort: const [
          SortOption('last_message_at', direction: -1),
        ],

        onChannelTap: (channel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: const ChatView(),
              ),
            ),
          );
        },
      ),
    );
  }
}