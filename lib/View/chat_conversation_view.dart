import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medshift/Controller/chat_Controller.dart';

class ChatConversationView extends StatefulWidget {
  final String conversationId;
  final String otherUserName;

  const ChatConversationView({
    super.key,
    required this.conversationId,
    required this.otherUserName,
  });

  @override
  State<ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<ChatConversationView> {
  final controller = ChatController();
  final msgCtl = TextEditingController();
  final scrollCtl = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.marcarComoLida(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    final myUid = controller.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.mensagensStream(widget.conversationId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollCtl.hasClients) {
                    scrollCtl.jumpTo(scrollCtl.position.maxScrollExtent);
                  }
                });

                return ListView.builder(
                  controller: scrollCtl,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final bool minha = data['senderId'] == myUid;

                    final ts = data['createdAt'] as Timestamp?;
                    final hora = ts != null
                        ? DateFormat('HH:mm').format(ts.toDate())
                        : '';

                    return Row(
                      mainAxisAlignment: minha
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: minha
                                ? const Color(0xFFD2E3FC)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(14),
                              topRight: const Radius.circular(14),
                              bottomLeft: minha
                                  ? const Radius.circular(14)
                                  : Radius.zero,
                              bottomRight: minha
                                  ? Radius.zero
                                  : const Radius.circular(14),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: minha
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['text'] ?? '',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hora,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgCtl,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (text) async {
                        if (text.trim().isEmpty) return;

                        msgCtl.clear();
                        await controller.enviarMensagem(
                          widget.conversationId,
                          text,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Digite sua mensagem...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF1976D2),
                    onPressed: () async {
                      final text = msgCtl.text.trim();
                      if (text.isEmpty) return;

                      msgCtl.clear();
                      await controller.enviarMensagem(
                        widget.conversationId,
                        text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
