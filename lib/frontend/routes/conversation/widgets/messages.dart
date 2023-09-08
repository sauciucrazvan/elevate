import 'package:elevate/frontend/routes/conversation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/conversation/conversation_service.dart';
import 'package:lottie/lottie.dart';

class Messages extends StatelessWidget {
  final ConversationService conversationService;
  final ScrollController scrollController;

  final String senderId;
  final String receiverId;

  const Messages({
    super.key,
    required this.conversationService,
    required this.senderId,
    required this.receiverId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          conversationService.getConversation(senderId, receiverId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Lottie.asset(
              "assets/animations/error.json",
              width: 128,
              height: 128,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              "assets/animations/loading.json",
              width: 128,
              height: 128,
            ),
          );
        }

        if (!snapshot.hasData) return Container();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });

        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs
              .map((document) => ChatBubble(document: document))
              .toList(),
        );
      },
    );
  }
}
