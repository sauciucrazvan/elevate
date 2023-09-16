import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:elevate/frontend/widgets/pictures/avatar.dart';
import 'package:elevate/frontend/widgets/dialogs/confirm_dialog.dart';

import 'package:elevate/backend/domains/users/user_service.dart';
import 'package:elevate/backend/domains/pictures/avatar_service.dart';
import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var username = getUsername(FirebaseAuth.instance.currentUser)!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                StreamBuilder(
                  stream: AvatarService().onAvatarUpdate,
                  builder: (context, snapshot) => Avatar(
                    username: getUsername(FirebaseAuth.instance.currentUser)!,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "@$username",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Member since",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                FutureBuilder(
                  future: UserService().getRegisterDate(),
                  builder: (context, snapshot) {
                    DateTime registerDate = DateTime.now();

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      registerDate = snapshot.data!;
                    }

                    return Text(
                      DateFormat("MMM dd yyyy, HH:mm").format(registerDate),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    );
                  },
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
                        onTap: () => AvatarService().changeAvatar(context),
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
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(username)
                                  .update({'token': ''});

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
      ),
    );
  }
}
