import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  // Instance of Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  // Sign up
  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    }
  }

  // Checking the connection (Debug)
  // Future<void> checkFirebaseConnection() async {
  //   try {
  //     final user = _firebaseAuth.currentUser;

  //     if (user != null) {
  //       print('Connected as: ${user.uid}');
  //     } else {
  //       print('You\'re not connected.');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
