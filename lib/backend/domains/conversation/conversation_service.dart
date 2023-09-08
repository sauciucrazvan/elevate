import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:elevate/backend/private_keys/keys.dart';
import 'package:elevate/backend/functions/username/get_username.dart';

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

    // Encrypting the message
    final encrypter = encrypt.Encrypter(encrypt.AES(getEncryptionKey()));
    final encryptedMessage = encrypter.encrypt(message, iv: IV.fromLength(8));

    await firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .add({
      'senderId': senderId,
      'senderName': senderName ?? "Unknown",
      'receiverId': receiverId,
      'message': encryptedMessage.base64,
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

  String decryptMessage(String encryptedMessage) {
    final encrypter = encrypt.Encrypter(encrypt.AES(getEncryptionKey()));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedMessage),
        iv: IV.fromLength(8));
  }
}
