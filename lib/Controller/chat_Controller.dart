import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get uid => auth.currentUser!.uid;

  Future<String> getOrCreateConversation(String otherUid) async {
    final query = await db
        .collection('conversations')
        .where('members', arrayContains: uid)
        .get();

    for (var doc in query.docs) {
      final members = List<String>.from(doc['members']);
      if (members.contains(otherUid)) {
        return doc.id;
      }
    }

    final docRef = await db.collection('conversations').add({
      'members': [uid, otherUid],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'unread': {
        uid: 0,
        otherUid: 0,
      },
    });

    return docRef.id;
  }

  Stream<QuerySnapshot> mensagensStream(String conversationId) {
    return db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<String?> enviarMensagem(String conversationId, String text) async {
    if (text.trim().isEmpty) return "Mensagem vazia!";

    final convoRef = db.collection('conversations').doc(conversationId);

    await convoRef.collection('messages').add({
      'senderId': uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await db.runTransaction((tx) async {
      final snap = await tx.get(convoRef);
      final data = snap.data() as Map<String, dynamic>;
      final members = List<String>.from(data['members']);

      for (final m in members) {
        if (m != uid) {
          tx.update(convoRef, {
            'updatedAt': FieldValue.serverTimestamp(),
            'unread.$m': FieldValue.increment(1),
          });
        }
      }
    });

    return null; 
  }

  Future<void> marcarComoLida(String conversationId) async {
    await db.collection('conversations').doc(conversationId).update({
      'unread.$uid': 0,
    });
  }
}
