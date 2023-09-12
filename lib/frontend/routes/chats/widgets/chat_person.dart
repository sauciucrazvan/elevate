import 'package:elevate/backend/domains/conversation/conversation_service.dart';
import 'package:elevate/backend/functions/conversations/get_channelid.dart';
import 'package:elevate/backend/functions/limit_string.dart';
import 'package:elevate/backend/functions/time_convertor.dart';
import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:elevate/frontend/routes/conversation/conversation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPerson extends StatefulWidget {
  final String displayName;

  const ChatPerson({
    super.key,
    required this.displayName,
  });

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  String senderName = getUsername(FirebaseAuth.instance.currentUser)!;

  @override
  Widget build(BuildContext context) {
    String channelId = getChannelID(senderName, widget.displayName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Conversation(
                receiverName: widget.displayName,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "@${widget.displayName}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    StreamBuilder(
                      stream: ConversationService()
                          .getLastMessageTextStream(channelId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshot.hasError) {
                          throw Exception(snapshot.error);
                        }

                        final lastMessage = snapshot.data;

                        if (lastMessage == null || lastMessage.isEmpty) {
                          return Container();
                        }

                        final messageSender = lastMessage['senderName'];
                        final messageText = lastMessage['message']!;
                        final messageDate = lastMessage['date']!;

                        DateTime date = DateTime.parse(messageDate);

                        return Row(
                          children: [
                            Text(
                              "$messageSender: ${limitString(messageText, 32)} ⦁ ${convertTime(date)}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
