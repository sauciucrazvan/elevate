import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate/backend/domains/friends/friends_service.dart';
import 'package:elevate/frontend/routes/friends/widgets/friend.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/widgets/buttons/leading_button/back_button.dart';

class SearchFriends extends StatefulWidget {
  final String username;

  const SearchFriends({super.key, required this.username});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  bool queryStatus = false;

  late Timer _timer;
  int dots = 1;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          if (queryStatus) _timer.cancel();
          setState(() {
            if (dots < 3) {
              dots++;
            } else {
              dots = 1;
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color backgroundColor = Theme.of(context).colorScheme.background;

    String title = (queryStatus
        ? "Results for '${widget.username}'"
        : "Searching for '${widget.username}'${'.' * dots}");

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/AppIcon.png",
          width: 32,
          height: 32,
        ),
        centerTitle: true,
        leading: const BackLeadingButton(),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Icon(
                  queryStatus ? Icons.list_rounded : Icons.search,
                  color: primaryColor,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 4),
            StreamBuilder(
              stream: FriendsService().searchFriends(widget.username),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  throw Exception(snapshot.error);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                queryStatus = true;

                if (!snapshot.hasData) {
                  return Container();
                }

                final userList = snapshot.data!.docs.map((doc) {
                  return {
                    'name': doc.id,
                    'days': DateTime.now()
                        .difference(
                            ((doc.data() as Map)['addedAt'] as Timestamp)
                                .toDate())
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

                    return Friend(
                      friendName: username as String,
                      friendDays: days as int,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
