import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medshift/View/components/popup_menu.dart';
import 'package:medshift/Controller/chat_Controller.dart';
import 'package:medshift/View/chat_conversation_view.dart';

class MedicosView extends StatelessWidget {
  const MedicosView({super.key});

  String formatarData(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    try {
      final data = DateTime.parse(iso);
      return DateFormat('dd/MM/yyyy').format(data);
    } catch (_) {
      return "-";
    }
  }

  Widget _ultimaMensagem(String medicoId, String meuUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .where('members', arrayContains: meuUid)
          .orderBy('updatedAt', descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        QueryDocumentSnapshot? conversa;

        for (final doc in snapshot.data!.docs) {
          final members = List<String>.from(doc['members']);
          if (members.length == 2 && members.contains(medicoId)) {
            conversa = doc;
            break;
          }
        }

        if (conversa == null) {
          return const Text(
            "Nenhuma mensagem",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          );
        }

        final data = conversa.data() as Map<String, dynamic>;

        final msg = data['lastMessage'] ?? '';
        final ts = data['lastMessageAt'] as Timestamp?;

        final hora =
            ts != null ? DateFormat('HH:mm').format(ts.toDate()) : '';

        return Row(
          children: [
            Expanded(
              child: Text(
                msg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              hora,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatController = ChatController();
    final meuUid = chatController.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),

      appBar: AppBar(
        title: const Text(
          "Médicos Cadastrados",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
        actions: [buildPopupMenu(context)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("usuarios")
              .orderBy("nomeLower")
              .snapshots(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text("Nenhum médico encontrado."));
            }

            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final medicoId = doc.id;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF1976D2),
                      child: Text(
                        (data["nome"] ?? "?")
                            .toString()
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      data["nome"] ?? "Nome não informado",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["email"] ?? "-",
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        _ultimaMensagem(medicoId, meuUid),
                      ],
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: const Color(0xFF1976D2),
                      onPressed: () async {
                        final conversationId =
                            await chatController.getOrCreateConversation(
                          medicoId,
                        );

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatConversationView(
                              conversationId: conversationId,
                              otherUserName: data["nome"] ?? "Médico",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
