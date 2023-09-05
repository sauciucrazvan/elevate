import 'package:elevate/frontend/config/palette.dart';
import 'package:flutter/material.dart';

class Elevate extends StatelessWidget {
  const Elevate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Container(),
    );
  }
}
