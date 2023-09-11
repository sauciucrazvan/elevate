import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/frontend/routes/friends/sub_pages/widgets/friend_tile.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/buttons/leading_button/back_button.dart';

class ViewRequests extends StatelessWidget {
  const ViewRequests({super.key});

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/AppIcon.png",
          width: 32,
          height: 32,
        ),
        centerTitle: true,
        leading: const BackLeadingButton(),
        backgroundColor: secondaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Viewing your friend requests",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
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

              if (requestsMap.isEmpty) return const Text("No friend requests");

              return Expanded(
                child: ListView.builder(
                  itemCount: requestsMap.length,
                  itemBuilder: (context, index) {
                    String displayName = requestsMap.keys.elementAt(index);
                    return FriendTile(displayName: displayName);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
