import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3498DB),
    secondary: Color(0xFF757575),
    background: Color(0xFFF5F5F5),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Color(0xFF333333), fontSize: 12),
    bodyMedium: TextStyle(color: Color(0xFF333333), fontSize: 16),
    bodyLarge: TextStyle(color: Color(0xFF333333), fontSize: 20),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3498DB),
    secondary: Color(0xFF121212),
    background: Color(0xFF212121),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
    bodyMedium: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),
  ),
);
