import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/toggable.dart';

import 'package:elevate/frontend/routes/friends/widgets/friend_tile.dart';

class RequestsCounter extends StatefulWidget {
  const RequestsCounter({super.key});

  @override
  State<RequestsCounter> createState() => _RequestsCounterState();
}

class _RequestsCounterState extends State<RequestsCounter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Toggable(
          title: "Manage your friend requests",
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      "Friend requests",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    StreamBuilder(
                      stream: FriendsService().getRequestsStream(),
                      builder: (context, snapshot) {
                        int friends = 0;

                        if (snapshot.hasData && snapshot.data != null) {
                          friends = snapshot.data!.length;
                        }

                        return Text(
                          friends.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.group,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
                StreamBuilder<Map<String, dynamic>>(
                  stream: FriendsService().getRequestsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      throw Exception(snapshot.error);
                    }

                    Map<String, dynamic> requestsMap = snapshot.data ?? {};

                    if (requestsMap.isEmpty) {
                      return Container();
                    }

                    return SizedBox(
                      height: requestsMap.length * 50,
                      child: ListView.builder(
                        itemCount: requestsMap.length,
                        itemBuilder: (context, index) {
                          String displayName =
                              requestsMap.keys.elementAt(index);
                          return FriendTile(displayName: displayName);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
