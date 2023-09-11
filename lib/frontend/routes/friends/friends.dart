import 'package:elevate/frontend/routes/friends/components/requests_counter.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/routes/friends/components/send_request.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const RequestsCounter(),
          const SizedBox(height: 16),
          const SendRequest(),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Friends (0)",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
