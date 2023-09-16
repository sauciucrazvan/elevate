import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/backend/functions/username/safe_username.dart';

import 'package:elevate/frontend/routes/friends/widgets/friend.dart';
import 'package:elevate/frontend/routes/friends/components/search_friends.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';
import 'package:elevate/frontend/widgets/text/field_with_button.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Friends",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 4),
              ButtonedField(
                textEditingController: textEditingController,
                description: 'Search a friend...',
                icon: Icons.search,
                maxLength: 16,
                padding: 0,
                onPressed: () {
                  String username = textEditingController.text.toLowerCase();

                  // Checks
                  if (username.isEmpty) return;

                  if (username.length < 3) {
                    return showElevatedNotification(
                        context, "Search query too short!", Colors.red);
                  }

                  if (!isUsernameSafe(username)) {
                    return showElevatedNotification(
                        context, "Invalid username format!", Colors.red);
                  }

                  textEditingController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchFriends(username: username),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              StreamBuilder(
                stream: FriendsService().getFriendsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    throw Exception(snapshot.error);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final userList = snapshot.data!.docs.map((doc) {
                    return {
                      'name': doc.id,
                      'days': DateTime.now()
                          .difference(
                              (doc.data()['addedAt'] as Timestamp).toDate())
                          .inDays,
                    };
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final username = userList[index]['name'] ?? "unknown";
                      final days = userList[index]['days'] ?? 0;

                      return Friend(
                        friendName: username as String,
                        friendDays: days as int,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
