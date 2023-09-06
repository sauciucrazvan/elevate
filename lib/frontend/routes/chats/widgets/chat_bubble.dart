import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String id;
  final String displayName;
  final bool unreadMessages;
  final bool pinnedConversation;

  const ChatBubble({
    super.key,
    required this.id,
    required this.displayName,
    required this.unreadMessages,
    required this.pinnedConversation,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
          child: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (widget.unreadMessages)
                      Text(
                        "You have unread messages with ${widget.displayName}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const Spacer(),
                if (widget.pinnedConversation) ...[
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                ],
                Icon(
                  Icons.chat,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
