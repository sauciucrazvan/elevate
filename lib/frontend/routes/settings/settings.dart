import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                "Application Settings",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              const Divider(),
              ListTile(
                title: Text(
                  "About Elevate",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () async {
                  final Uri uri = Uri(
                    scheme: 'https',
                    host: "github.com",
                    path: "/sauciucrazvan/elevate",
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.inAppWebView,
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    showElevatedNotification(context,
                        "There was an error opening the URL.", Colors.red);
                  }
                },
                tileColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              const Divider(),
              const SizedBox(height: 4),
              Text(
                "Account Settings",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                "You're logged in as @${getUsername(FirebaseAuth.instance.currentUser)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              const Divider(),
              ListTile(
                title: Text(
                  "Sign out",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: "Are you sure you want to logout?",
                    confirm: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                  ),
                ),
                tileColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
