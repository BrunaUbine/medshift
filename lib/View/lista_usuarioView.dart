import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../View/chatview.dart';
import '../utils/chat_helpers.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final myId = StreamChat.of(context).currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuários"),
        backgroundColor: const Color(0xFF1976D2),
      ),

      body: FutureBuilder(
        future: client.queryUsers(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snap.data!.users.where((u) => u.id != myId).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                leading: CircleAvatar(child: Text(u.name[0])),
                title: Text(u.name),
                onTap: () async {
                  final chatId = gerarChatId(myId, u.id);

                  final channel = client.channel(
                    'messaging',
                    id: chatId,
                    extraData: {
                      'members': [myId, u.id],
                    },
                  );

                  await channel.watch();

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
