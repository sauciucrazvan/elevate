import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate/backend/functions/username/get_username.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<DateTime> getRegisterDate() async {
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection('users')
        .doc(getUsername(firebaseAuth.currentUser))
        .get();

    final data = documentSnapshot.data();

    if (data is! Map || !documentSnapshot.exists) return DateTime.now();

    return (data['registeredAt'] as Timestamp).toDate();
  }
}
