import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:elevate/backend/domains/rate_limit/rate_limit_service.dart';
import 'package:elevate/backend/domains/conversation/conversation_service.dart';

import 'package:elevate/frontend/routes/conversation/widgets/messages.dart';

import 'package:elevate/frontend/widgets/pictures/avatar.dart';
import 'package:elevate/frontend/widgets/text/field_with_button.dart';
import 'package:elevate/frontend/widgets/buttons/leading_button/back_button.dart';

class Conversation extends StatefulWidget {
  final String receiverName;

  const Conversation({super.key, required this.receiverName});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final ConversationService conversationService = ConversationService();

    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: const BackLeadingButton(),
        title: Text(
          "@${widget.receiverName}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(username: widget.receiverName),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Text(
            "You can only view messages from the last 24 hours",
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: 8),

          // Messages
          Expanded(
            child: Messages(
              conversationService: conversationService,
              senderName: getUsername(firebaseAuth.currentUser!)!,
              receiverName: widget.receiverName,
              scrollController: scrollController,
            ),
          ),

          // Text Field
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ButtonedField(
                    description: 'Message...',
                    textEditingController: messageController,
                    maxLength: 256,
                    padding: 8.0,
                    icon: Icons.arrow_forward_ios_rounded,
                    onPressed: () async {
                      if (!RateLimitService().canPerformAction(context)) return;

                      String text = messageController.text;
                      messageController.clear();

                      await conversationService.sendMessage(
                          widget.receiverName, text);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
