import 'package:flutter/material.dart';

import 'package:elevate/frontend/routes/authentication/login/login.dart';
import 'package:elevate/frontend/routes/authentication/register/register.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool hasAccount = true;

  void switchPages() {
    setState(() {
      hasAccount = !hasAccount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasAccount) {
      return Login(
        switchPages: switchPages,
      );
    }
    return Register(
      switchPages: switchPages,
    );
  }
}
