import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/friends/friends_service.dart';

import 'package:elevate/frontend/routes/chats/widgets/chat_person.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    "Contacts",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                StreamBuilder(
                  stream: FriendsService().getFriendsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      throw Exception(snapshot.error);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return Container();
                    }

                    final userList = snapshot.data!.docs.map((doc) {
                      return {
                        'name': doc.id,
                        'days': DateTime.now()
                            .difference(
                                (doc.data()['addedAt'] as Timestamp).toDate())
                            .inDays,
                      };
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        final username = userList[index]['name'] ?? "unknown";
                        final days = userList[index]['days'] ?? 0;

                        return ChatPerson(
                          displayName: username as String,
                          friendDays: days as int,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
