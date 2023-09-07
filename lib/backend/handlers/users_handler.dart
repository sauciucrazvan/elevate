import 'package:cloud_firestore/cloud_firestore.dart';

void createUser(String uid, String username) {
  // Instance of Firebase Firestore
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Creating the user in the database
  firebaseFirestore.collection('users').doc(username).set({
    'uid': uid,
  });
}
