import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
              ),
              const SizedBox(height: 8),
              Text(
                "@${getUsername(FirebaseAuth.instance.currentUser)}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 50),
              Text(
                "Account Settings",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Change avatar",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {},
                      tileColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(height: 4),
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
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
