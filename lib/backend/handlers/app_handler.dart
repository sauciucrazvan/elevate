import 'package:flutter/material.dart';

import 'package:elevate/frontend/config/palette.dart';

import 'package:elevate/backend/domains/authentication/authentication_gateway.dart';

class Elevate extends StatelessWidget {
  const Elevate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthenticationGateway(),
    );
  }
}
