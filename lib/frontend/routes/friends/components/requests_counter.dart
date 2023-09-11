import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/frontend/routes/friends/sub_pages/view_requests.dart';

class RequestsCounter extends StatelessWidget {
  const RequestsCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ViewRequests())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Manage your friend requests",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
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
                      return Text(
                        snapshot.data.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.group_add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
