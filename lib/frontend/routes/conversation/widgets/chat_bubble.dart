import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';
import 'package:elevate/backend/domains/conversation/conversation_service.dart';

class ChatBubbles extends StatelessWidget {
  final String channelId;
  final DocumentSnapshot document;

  const ChatBubbles(
      {super.key, required this.document, required this.channelId});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool sentByUser =
        data['senderName'] == getUsername(FirebaseAuth.instance.currentUser);

    String message = data['message'];
    String iv = data['iv'];

    return Slidable(
      endActionPane: sentByUser
          ? ActionPane(
              extentRatio: 0.15,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  onPressed: (context) => showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title:
                          "Are you sure you want to continue deleting this message?\nThis action cannot be undone!",
                      confirm: () {
                        ConversationService()
                            .deleteMessage(channelId, document.id);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
            )
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          left: sentByUser ? 48.0 : 8.0,
          right: sentByUser ? 8.0 : 48.0,
          bottom: 4.0,
          top: 4.0,
        ),
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
                  ConversationService().decryptMessage(message, iv),
                  style: sentByUser
                      ? const TextStyle(color: Colors.white)
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
