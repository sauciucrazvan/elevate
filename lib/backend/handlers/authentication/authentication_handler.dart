import 'package:flutter/material.dart';

import 'package:elevate/backend/functions/username/safe_username.dart';
import 'package:elevate/backend/functions/username/create_username.dart';
import 'package:elevate/backend/domains/authentication/authentication_service.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';

void loginUser(BuildContext context, String name, String password) {
  if (name.isEmpty || password.isEmpty) {
    return showElevatedNotification(
        context, "You can't submit an empty field.", Colors.red);
  }

  if (!isUsernameSafe(name)) {
    return showElevatedNotification(
        context,
        "Invalid username format: use only letters, numbers and underscore.",
        Colors.red);
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  AuthenticationService().signIn(context, createUsername(name), password);
}

void createAccount(BuildContext context, String name, String password,
    String confirmPassword) {
  if (name.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

  if (!isUsernameSafe(name)) {
    return showElevatedNotification(
        context,
        "Invalid username. Please use only letters, numbers and underscore.",
        Colors.red);
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  AuthenticationService().signUp(context, createUsername(name), password);
}
