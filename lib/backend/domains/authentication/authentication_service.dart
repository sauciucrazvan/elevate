// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';

class AuthenticationService {
  // Instances of Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Sign in
  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (Navigator.of(context).canPop()) Navigator.pop(context);

      return true;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-credential":
          showElevatedNotification(context, "Invalid credentials!", Colors.red);
          break;
        case "user-disabled":
          showElevatedNotification(
              context, "Your account is disabled!", Colors.red);
          break;
        case "user-not-found":
          showElevatedNotification(context, "User not found.", Colors.red);
          break;
        case "wrong-password":
          showElevatedNotification(context, "Wrong password!", Colors.red);
          break;
        case "invalid-email":
          showElevatedNotification(context,
              "The email adress you've provided is invalid.", Colors.red);
          break;
        case "network-request-failed":
          showElevatedNotification(
              context,
              "Please connect to the internet in order to use the app.",
              Colors.red);
          break;
        default:
          showElevatedNotification(context, error.code, Colors.red);
      }
      if (Navigator.of(context).canPop()) Navigator.pop(context);
      return false;
    }
  }

  // Sign up
  Future<bool> signUp(
      BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firebaseFirestore
          .collection('users')
          .doc(email.substring(0, email.indexOf("@")))
          .set({'registeredAt': DateTime.now()});

      if (Navigator.of(context).canPop()) Navigator.pop(context);

      return true;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          showElevatedNotification(
              context, "The username is not available!", Colors.red);
          break;
        case "invalid-email":
          showElevatedNotification(context,
              "The email adress you've provided is invalid.", Colors.red);
          break;
        case "weak-password":
          showElevatedNotification(
              context, "The password you chose is to weak.", Colors.red);
          break;
        case "network-request-failed":
          showElevatedNotification(
              context,
              "Please connect to the internet in order to use the app.",
              Colors.red);
          break;
        default:
          showElevatedNotification(context, error.code, Colors.red);
      }
      if (Navigator.of(context).canPop()) Navigator.pop(context);
      return false;
    }
  }
}
