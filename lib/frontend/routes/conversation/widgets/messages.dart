import 'package:elevate/backend/functions/conversations/get_channelid.dart';
import 'package:elevate/frontend/routes/conversation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/conversation/conversation_service.dart';
import 'package:lottie/lottie.dart';

class Messages extends StatelessWidget {
  final ConversationService conversationService;
  final ScrollController scrollController;

  final String senderName;
  final String receiverName;

  const Messages({
    super.key,
    required this.conversationService,
    required this.senderName,
    required this.receiverName,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: conversationService
          .getConversation(senderName, receiverName)
          .snapshots(),
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

        String channelId = getChannelID(senderName, receiverName);

        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs
              .map((document) => ChatBubbles(
                    document: document,
                    channelId: channelId,
                  ))
              .toList(),
        );
      },
    );
  }
}
