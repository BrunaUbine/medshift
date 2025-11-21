import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'users_list_view.dart';
import 'chat_view.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = StreamChat.of(context).currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversas"),
        backgroundColor: const Color(0xFF1976D2),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersListView()),
              );
            },
          ),
        ],
      ),

      body: ChannelsBloc(
        child: ChannelListView(
          filter: Filter.in_(
            'members',
            [userId],
          ),
          sort: const [SortOption('last_message_at')],
          pagination: const PaginationParams(limit: 30),
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
      ),
    );
  }
}
