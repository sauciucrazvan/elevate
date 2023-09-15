import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';

class RateLimitService {
  // Singleton class
  static final RateLimitService _instance = RateLimitService._internal();

  RateLimitService._internal();

  factory RateLimitService() {
    return _instance;
  }

  // Functions

  DateTime lastAction = DateTime.fromMicrosecondsSinceEpoch(0);

  bool canPerformAction(BuildContext context) {
    bool value =
        lastAction.add(const Duration(seconds: 2)).isBefore(DateTime.now());

    if (!value) {
      showElevatedNotification(context,
          "You're performing actions too fast! Be patient!", Colors.red);
    } else {
      lastAction = DateTime.now();
    }

    return value;
  }
}
