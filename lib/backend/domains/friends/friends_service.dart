// ignore_for_file: use_build_context_synchronously

import 'package:elevate/backend/functions/conversations/get_channelid.dart';
import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class FriendsService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendFriendRequest(
      BuildContext context, String receiverName) async {
    if (receiverName.isEmpty) return;

    String? senderName = getUsername(firebaseAuth.currentUser!);

    if (senderName == receiverName) return;

    DocumentReference userDocRef =
        firebaseFirestore.collection('users').doc(receiverName);

    try {
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        bool friendRequestExists =
            await checkIfFriendRequestExists(senderName!, receiverName);

        if (friendRequestExists) {
          showElevatedNotification(
            context,
            "There's already a request sent by or to $receiverName!",
            Colors.red,
          );
          return;
        }

        bool isAlreadyFriend =
            await checkIfIsFriendAlready(senderName, receiverName);

        if (isAlreadyFriend) {
          showElevatedNotification(
            context,
            "You're already friends with $receiverName!",
            Colors.red,
          );
          return;
        }

        await firebaseFirestore
            .collection('users')
            .doc(receiverName)
            .collection('requests')
            .doc(senderName)
            .set({'sentAt': DateTime.now().toString()});

        showElevatedNotification(context,
            "Friend request sent to $receiverName!", Colors.lightGreen);
        return;
      } else {
        showElevatedNotification(
            context, "Can't find $receiverName", Colors.red);
        return;
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> checkIfIsFriendAlready(
      String senderName, String receiverName) async {
    DocumentSnapshot docSnapshotSender = await firebaseFirestore
        .collection('users')
        .doc(receiverName)
        .collection('friends')
        .doc(senderName)
        .get();

    return docSnapshotSender.exists;
  }

  Future<bool> checkIfFriendRequestExists(
      String senderName, String receiverName) async {
    DocumentSnapshot docSnapshotSender = await firebaseFirestore
        .collection('users')
        .doc(receiverName)
        .collection('requests')
        .doc(senderName)
        .get();

    DocumentSnapshot docSnapshotReceiver = await firebaseFirestore
        .collection('users')
        .doc(senderName)
        .collection('requests')
        .doc(receiverName)
        .get();

    return docSnapshotSender.exists || docSnapshotReceiver.exists;
  }

  Future<int> getRequestsCount() async {
    String username = getUsername(firebaseAuth.currentUser)!;

    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('requests')
        .get();

    return querySnapshot.size;
  }

  Future<int> getFriendsCount() async {
    String username = getUsername(firebaseAuth.currentUser)!;

    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('friends')
        .get();

    return querySnapshot.size;
  }

  Stream<Map<String, dynamic>> getRequestsStream() {
    String username = getUsername(firebaseAuth.currentUser)!;

    Stream<QuerySnapshot> querySnapshotStream = firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('requests')
        .snapshots();

    return querySnapshotStream.map((querySnapshot) {
      Map<String, dynamic> requestsMap = {};

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        requestsMap[docSnapshot.id] = docSnapshot.data();
      }

      return requestsMap;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getUsername(FirebaseAuth.instance.currentUser))
        .collection('friends')
        .snapshots();
  }

  void declineFriendRequest(String senderName) async {
    String username = getUsername(firebaseAuth.currentUser)!;

    await firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('requests')
        .doc(senderName)
        .delete();
  }

  void acceptFriendRequest(String senderName) async {
    String username = getUsername(firebaseAuth.currentUser)!;

    declineFriendRequest(senderName);

    String date = DateTime.now().toString();

    await firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('friends')
        .doc(senderName)
        .set({'addedAt': date});

    await firebaseFirestore
        .collection('users')
        .doc(senderName)
        .collection('friends')
        .doc(username)
        .set({'addedAt': date});
  }

  void removeFriend(String friendName) async {
    String username = getUsername(firebaseAuth.currentUser)!;

    String channelId = getChannelID(username, friendName);

    await firebaseFirestore
        .collection('channels')
        .doc(channelId)
        .collection('messages')
        .get()
        .then((document) => {
              for (QueryDocumentSnapshot doc in document.docs)
                {doc.reference.delete()}
            });

    await firebaseFirestore
        .collection('users')
        .doc(username)
        .collection('friends')
        .doc(friendName)
        .delete();

    await firebaseFirestore
        .collection('users')
        .doc(friendName)
        .collection('friends')
        .doc(username)
        .delete();
  }
}
