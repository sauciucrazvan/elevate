import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    if (message.isEmpty) return;

    String senderId = firebaseAuth.currentUser!.uid;
    String? senderName = getUsername(firebaseAuth.currentUser!);

    // Channel ID determined by their sorted IDs
    List ids = [senderId, receiverId];
    ids.sort();
    String channelId = ids.join(".");

    await firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .add({
      'senderId': senderId,
      'senderName': senderName ?? "Unknown",
      'receiverId': receiverId,
      'message': message,
      'date': DateTime.now()
    });
  }

  void deleteOldMessages(String channelId) {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 1));

    firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .where("date", isLessThan: cutoffDate)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Query<Map<String, dynamic>> getConversation(
      String senderId, String receiverId) {
    // Channel ID determined by their sorted IDs
    List ids = [senderId, receiverId];
    ids.sort();
    String channelId = ids.join(".");

    deleteOldMessages(channelId);

    return firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .orderBy("date", descending: false);
  }
}
