import 'package:flutter/material.dart';

// Firebase Packages & Settings
import 'package:firebase_core/firebase_core.dart';
import 'package:elevate/backend/private_keys/firebase_options.dart';

// Application handler
import 'package:elevate/backend/handlers/app_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Elevate());
}
