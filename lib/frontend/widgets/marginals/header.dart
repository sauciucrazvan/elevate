// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

AppBar Header(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Image.asset(
      "assets/images/AppIcon.png",
      width: 32,
      height: 32,
    ),
    centerTitle: true,
    shadowColor: Colors.transparent,
  );
}
