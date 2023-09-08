import 'package:flutter/material.dart';

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
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                "Account",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "You're logged in as @${getUsername(FirebaseAuth.instance.currentUser)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 4,
              ),
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
