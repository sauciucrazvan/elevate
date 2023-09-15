import 'package:elevate/frontend/widgets/toggable.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/text/field_with_button.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/backend/domains/rate_limit/rate_limit_service.dart';

class SendRequest extends StatelessWidget {
  const SendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Toggable(
          title: "Send a friend request!",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ButtonedField(
                  textEditingController: textEditingController,
                  description: 'Username',
                  maxLength: 16,
                  padding: 4,
                  icon: Icons.group_add,
                  onPressed: () {
                    if (!RateLimitService().canPerformAction(context)) return;

                    String receiverName = textEditingController.text;
                    textEditingController.clear();
                    FriendsService().sendFriendRequest(context, receiverName);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
