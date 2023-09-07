import 'package:firebase_auth/firebase_auth.dart';

String? getUsername(User? user) {
  return user!.email?.substring(0, user.email?.indexOf("@"));
}
