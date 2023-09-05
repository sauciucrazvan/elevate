import 'package:elevate/frontend/routes/authentication/login/login.dart';
import 'package:flutter/material.dart';

import 'package:elevate/frontend/config/palette.dart';
//import 'package:elevate/frontend/routes/routes_handler.dart';

class Elevate extends StatelessWidget {
  const Elevate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const Login(),
    );
  }
}
