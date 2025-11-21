import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> addDoc(String collection, Map<String, dynamic> data) async {
    try {
      await db.collection(collection).add(data);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateDoc(
      String collection, String docId, Map<String, dynamic> data) async {
    try {
      await db.collection(collection).doc(docId).update(data);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteDoc(String collection, String docId) async {
    try {
      await db.collection(collection).doc(docId).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<DocumentSnapshot> getDoc(String collection, String docId) async {
    return await db.collection(collection).doc(docId).get();
  }

  Stream<QuerySnapshot> orderedStream(
      String collection, String field, bool descending) {
    return db
        .collection(collection)
        .orderBy(field, descending: descending)
        .snapshots();
  }
}
