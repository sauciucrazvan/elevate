import 'package:flutter/material.dart';
import 'package:elevate/frontend/routes/chats/widgets/chat_bubble.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Conversations",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const ChatBubble(
                id: 'test',
                displayName: '@razvan',
                unreadMessages: true,
                pinnedConversation: true,
              ),
              const ChatBubble(
                id: 'test',
                displayName: '@elevate',
                unreadMessages: false,
                pinnedConversation: true,
              ),
              const ChatBubble(
                id: 'test',
                displayName: '@default',
                unreadMessages: false,
                pinnedConversation: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
