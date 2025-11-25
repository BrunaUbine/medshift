import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../View/chatview.dart';
import '../View/lista_usuarioView.dart';

class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});

  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  bool loading = true;
  List<Channel> channels = [];
  String? error;

  @override
  void initState() {
    super.initState();
    carregarConversas();
  }

  Future<void> carregarConversas() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final client = StreamChat.of(context).client;

      if (client.currentUser == null) {
        setState(() {
          error = "Usuário não está conectado ao Stream.";
          loading = false;
        });
        return;
      }

      final userId = client.currentUser!.id;

      final resultado = await client.queryChannels(
        filter: Filter.in_("members", [userId]),
        sort: [SortOption("last_message_at", direction: -1)],
        paginationParams: const PaginationParams(limit: 30),
      );

      setState(() {
        channels = resultado;
        loading = false;
      });

    } catch (e) {
      setState(() {
        error = "Erro: $e";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: carregarConversas,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : channels.isEmpty
                  ? const Center(child: Text("Nenhuma conversa ainda."))
                  : ListView.builder(
                      itemCount: channels.length,
                      itemBuilder: (context, i) {
                        final channel = channels[i];

                        final name = channel.extraData["name"]?.toString()
                            ?? channel.state?.members
                                    .where((m) => m.user?.id != StreamChat.of(context).client.currentUser!.id)
                                    .map((m) => m.user?.name ?? m.user?.id)
                                    .join(", ")
                                ?? "Chat";

                        final lastMsg = channel.state?.lastMessage?.text ?? "";

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(name),
                          subtitle: Text(
                            lastMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
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
                    ),
    );
  }
}
