import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/frontend/widgets/buttons/small_button/small_button.dart';
import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';
import 'package:flutter/material.dart';

class FriendTile extends StatefulWidget {
  final String displayName;

  const FriendTile({
    super.key,
    required this.displayName,
  });

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${widget.displayName}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              SmallButton(
                icon: Icons.check,
                color: Colors.lightGreen.shade800,
                pressed: () {
                  FriendsService().acceptFriendRequest(widget.displayName);
                  showElevatedNotification(
                    context,
                    "You're now friends with ${widget.displayName}",
                    Colors.lightGreen.shade800,
                  );
                },
              ),
              const SizedBox(width: 8),
              SmallButton(
                icon: Icons.close,
                color: Colors.red,
                pressed: () {
                  FriendsService().declineFriendRequest(widget.displayName);
                  showElevatedNotification(
                    context,
                    "Declined the friend request from ${widget.displayName}",
                    Colors.lightGreen.shade800,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
