import 'package:elevate/backend/domains/pictures/avatar_service.dart';
import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AvatarService avatarService = AvatarService();

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
              CircleAvatar(
                radius: 48,
                child: StreamBuilder<void>(
                  stream: avatarService.onAvatarUpdate,
                  builder: (context, snapshot) {
                    return FutureBuilder<String?>(
                      future: avatarService.getAvatar(
                        getUsername(FirebaseAuth.instance.currentUser)!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError ||
                            snapshot.data == null) {
                          return Image.asset('assets/images/AppIcon.png');
                        }

                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
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
                      onTap: () async {
                        bool completed = await avatarService.pickAvatar();
                        if (!completed) {
                          // ignore: use_build_context_synchronously
                          showElevatedNotification(
                              context,
                              "There was an error uploading your avatar.",
                              Colors.red);
                        }
                      },
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
