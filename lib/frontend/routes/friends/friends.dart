import 'package:elevate/frontend/routes/friends/components/friends_list.dart';
import 'package:elevate/frontend/routes/friends/components/requests_counter.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/routes/friends/components/send_request.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          RequestsCounter(),
          SizedBox(height: 16),
          SendRequest(),
          SizedBox(height: 16),
          FriendsList(),
        ],
      ),
    );
  }
}
