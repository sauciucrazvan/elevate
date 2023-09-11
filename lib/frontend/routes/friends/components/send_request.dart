import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/text/field_with_button.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';

class SendRequest extends StatelessWidget {
  const SendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Send a friend request!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
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
                  String receiverName = textEditingController.text;
                  textEditingController.clear();
                  FriendsService().sendFriendRequest(context, receiverName);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
