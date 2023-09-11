import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:elevate/backend/private_keys/keys.dart';

import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:elevate/backend/functions/conversations/get_channelid.dart';

class ConversationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverName, String message) async {
    if (message.isEmpty) return;

    String? senderName = getUsername(firebaseAuth.currentUser!);

    // Channel ID determined by their sorted IDs
    String channelId = getChannelID(senderName ?? "Unknown", receiverName);

    // Encrypting the message
    final encrypter = encrypt.Encrypter(encrypt.AES(getEncryptionKey()));
    final encryptedMessage =
        encrypter.encrypt(message, iv: encrypt.IV.fromLength(8));

    await firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .add({
      'senderName': senderName ?? "Unknown",
      'message': encryptedMessage.base64,
      'date': DateTime.now()
    });
  }

  Future<void> deleteMessage(String channelId, String messageId) async {
    await firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  void deleteOldMessages(String channelId) async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 1));

    await firebaseFirestore
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
      String senderName, String receiverName) {
    // Channel ID determined by their sorted IDs
    String channelId = getChannelID(senderName, receiverName);

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
        iv: encrypt.IV.fromLength(8));
  }

  Stream<Set<String>?> getLastMessageTextStream(String channelId) {
    final streamController = StreamController<Set<String>?>();

    final query = firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .orderBy("date", descending: true)
        .limit(1);

    final subscription = query.snapshots().listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final lastMessageDoc = querySnapshot.docs.first;
        final lastMessageData = lastMessageDoc.data();
        final messageSender = lastMessageData['senderName'] as String;
        final encryptedMessage = lastMessageData['message'] as String;
        final messageDate = lastMessageData['date'] as Timestamp;

        final messageData = {
          messageSender,
          decryptMessage(encryptedMessage),
          messageDate.toDate().toString()
        };

        streamController.add(messageData);
      } else {
        streamController.add(null);
      }
    });

    // Închide stream-ul când nu mai este nevoie de el.
    streamController.onCancel = () {
      subscription.cancel();
    };

    return streamController.stream;
  }
}
