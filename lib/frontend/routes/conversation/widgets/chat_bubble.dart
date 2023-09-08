import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:elevate/backend/domains/conversation/conversation_service.dart';

class ChatBubble extends StatelessWidget {
  final String channelId;
  final DocumentSnapshot document;

  const ChatBubble(
      {super.key, required this.document, required this.channelId});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool sentByUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.15,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            onPressed: (context) =>
                ConversationService().deleteMessage(channelId, document.id),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Container(
          alignment: sentByUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                sentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: sentByUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ConversationService().decryptMessage(data['message']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
