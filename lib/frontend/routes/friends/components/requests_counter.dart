import 'package:elevate/frontend/widgets/toggable.dart';
import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/frontend/routes/friends/sub_pages/view_requests.dart';

class RequestsCounter extends StatefulWidget {
  const RequestsCounter({super.key});

  @override
  State<RequestsCounter> createState() => _RequestsCounterState();
}

class _RequestsCounterState extends State<RequestsCounter> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ViewRequests())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Toggable(
            title: "Manage your friend requests",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        "Friend requests",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      FutureBuilder(
                        future: FriendsService().getRequestsCount(),
                        builder: (context, snapshot) {
                          int friends = 0;

                          if (snapshot.hasData && snapshot.data != null) {
                            friends = snapshot.data!;
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
