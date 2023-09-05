import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final TextEditingController textEditingController;
  final String description;
  final bool obscureText;
  final int maxLength;
  final int maxLines;

  const Field({
    super.key,
    required this.textEditingController,
    required this.description,
    this.obscureText = false,
    this.maxLength = 64,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: TextField(
        controller: textEditingController,
        autocorrect: false,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: description,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
