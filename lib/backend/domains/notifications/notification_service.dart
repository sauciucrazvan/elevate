import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;

import 'package:elevate/backend/private_keys/keys.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class NotificationService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    final token = await firebaseMessaging.getToken();

    if (firebaseAuth.currentUser == null) return;

    firebaseFirestore
        .collection('users')
        .doc(getUsername(firebaseAuth.currentUser)!)
        .update({'token': token});
  }

  Future<void> sendNotification(String name, String title, String body) async {
    try {
      final userDoc = firebaseFirestore.collection('users').doc(name);

      final userDocSnapshot = await userDoc.get();
      if (userDocSnapshot.exists) {
        final userToken = userDocSnapshot.get('token') as String;

        await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/elevate-d8425/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $notificationAPIKey',
          },
          body: jsonEncode(
            {
              'message': {
                'notification': {
                  'title': title,
                  'body': body,
                },
                'android': {
                  'notification': {
                    'tag': title,
                  },
                },
                'token': userToken,
              },
            },
          ),
        );
      }
    } catch (e) {
      return;
    }
  }
}
