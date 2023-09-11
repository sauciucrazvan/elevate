import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elevate/frontend/routes/chats/widgets/chat_person.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Conversations",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              // show all users (temporary, till the friends feature comes in)
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    throw Exception(snapshot.error);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return const Text("No users");
                  }

                  final currentUid =
                      getUsername(FirebaseAuth.instance.currentUser);

                  final userList = snapshot.data!.docs
                      .where((doc) => doc.id != currentUid)
                      .map((doc) {
                    return {
                      'name': doc.id,
                    };
                  }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final username = userList[index]['name']!;

                      return ChatPerson(
                        displayName: username,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
