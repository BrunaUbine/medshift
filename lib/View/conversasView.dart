import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'chatview.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final currentUser = client.state.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não conectado ao Stream.")),
      );
    }

    final channelsStream = client.queryChannels(
      filter: Filter.in_('members', [currentUser.id]),
      channelStateSort: const [
        SortOption('last_message_at', direction: SortOption.DESC),
      ],
      watch: true,
      state: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversas"),
        backgroundColor: const Color(0xFF1976D2),
      ),

      body: StreamBuilder<List<Channel>>(
        stream: channelsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final channels = snapshot.data!;
          if (channels.isEmpty) {
            return const Center(
              child: Text("Nenhuma conversa encontrada."),
            );
          }

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (_, i) {
              final channel = channels[i];
              final lastMessage = channel.state?.lastMessage;

              return ListTile(
                title: Text(channel.name ?? "Conversa"),
                subtitle: Text(
                  lastMessage?.text ?? "Sem mensagens",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
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
              );
            },
          );
        },
      ),
    );
  }
}
