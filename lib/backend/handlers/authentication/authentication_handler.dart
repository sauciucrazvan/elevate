import 'package:elevate/backend/domains/authentication/authentication_service.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';

void loginUser(BuildContext context, String email, String password) {
  if (email.isEmpty || password.isEmpty) {
    return showElevatedNotification(
        context, "You can't submit an empty field.", Colors.red);
  }

  AuthenticationService().signIn(context, email, password);
}

void createAccount(BuildContext context, String email, String password,
    String confirmPassword) {
  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    return showElevatedNotification(
        context, "You can't submit an empty field.", Colors.red);
  }

  if (password.length < 8) {
    return showElevatedNotification(context,
        "The password has to be at least 8 characters long.", Colors.red);
  }

  if (password != confirmPassword) {
    return showElevatedNotification(
        context, "The passwords do not match!", Colors.red);
  }

  AuthenticationService().signUp(context, email, password);
}
