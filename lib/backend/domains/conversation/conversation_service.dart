import 'dart:async';

import 'package:elevate/backend/domains/notifications/notification_service.dart';
import 'package:elevate/backend/functions/limit_string.dart';
import 'package:encrypt/encrypt.dart';
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
    DateTime date = DateTime.now();

    // Channel ID determined by their sorted IDs
    String channelId = getChannelID(senderName ?? "Unknown", receiverName);

    // Encrypting the message
    IV iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(getEncryptionKey()));
    final encryptedMessage = encrypter.encrypt(message, iv: iv);

    // Adding it to the channel
    await firebaseFirestore
        .collection("channels")
        .doc(channelId)
        .collection("messages")
        .add({
      'senderName': senderName ?? "Unknown",
      'message': encryptedMessage.base64,
      'iv': iv.base64,
      'date': date
    });

    // Updating the last message date to every user
    await firebaseFirestore
        .collection("users")
        .doc(senderName)
        .collection("friends")
        .doc(receiverName)
        .update({'lastMessage': date});

    await firebaseFirestore
        .collection("users")
        .doc(receiverName)
        .collection("friends")
        .doc(senderName)
        .update({'lastMessage': date});

    await NotificationService().sendNotification(
        receiverName, "@$senderName", limitString(message, 32));
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

  String decryptMessage(String encryptedMessage, String iv) {
    final encrypter = encrypt.Encrypter(encrypt.AES(getEncryptionKey()));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedMessage),
        iv: encrypt.IV.fromBase64(iv));
  }

  Stream<Map<String, String>> getLastMessageTextStream(String channelId) {
    final streamController = StreamController<Map<String, String>>();

    deleteOldMessages(channelId);

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
        final iv = lastMessageData['iv'] as String;
        final messageDate = lastMessageData['date'] as Timestamp;

        final messageData = {
          'senderName': messageSender,
          'message': decryptMessage(encryptedMessage, iv),
          'date': messageDate.toDate().toString()
        };

        streamController.add(messageData);
      } else {
        streamController.add({});
      }
    });

    streamController.onCancel = () {
      subscription.cancel();
    };

    return streamController.stream;
  }
}
