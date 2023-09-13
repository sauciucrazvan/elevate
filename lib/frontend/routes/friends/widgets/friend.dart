import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';

import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';
import 'package:elevate/frontend/widgets/pictures/avatar.dart';

class Friend extends StatelessWidget {
  final String friendName;

  const Friend({super.key, required this.friendName});

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Avatar(username: friendName),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@$friendName",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title:
                        "Are you sure you want to remove @$friendName as your friend?\n\nHe will not be notified but your conversation is going to be deleted.",
                    confirm: () {
                      FriendsService().removeFriend(friendName);
                      Navigator.pop(context);
                    },
                  ),
                ),
                child: const SizedBox(
                  width: 25,
                  child: Icon(
                    Icons.person_remove,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
