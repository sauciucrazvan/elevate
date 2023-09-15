import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:elevate/frontend/routes/routes_handler.dart';
import 'package:elevate/frontend/routes/authentication/authentication.dart';

import 'package:elevate/backend/domains/notifications/notification_service.dart';

class AuthenticationGateway extends StatelessWidget {
  const AuthenticationGateway({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Checking if the user is logged in

        // If he's logged in, it will redirect over to the main page
        if (snapshot.hasData) {
          NotificationService().initNotifications();

          return const RouteHandler();
        }

        // If he's not, he will be redirected to the login page
        else {
          return const Authentication();
        }
      },
    );
  }
}
