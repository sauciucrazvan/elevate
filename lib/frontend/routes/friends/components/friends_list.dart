import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';

import 'package:elevate/frontend/routes/friends/widgets/friend.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
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
                    };
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final username = userList[index]['name'] ?? "unknown";

                      return Friend(friendName: username);
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
