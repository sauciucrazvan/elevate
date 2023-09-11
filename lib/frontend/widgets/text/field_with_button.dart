import 'package:flutter/material.dart';

class ButtonedField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String description;
  final bool obscureText;
  final int maxLength;
  final int maxLines;
  final double padding;
  final IconData icon;
  final Function? onPressed;

  const ButtonedField({
    super.key,
    required this.textEditingController,
    required this.description,
    this.obscureText = false,
    this.maxLength = 64,
    this.maxLines = 1,
    this.padding = 64,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextField(
        controller: textEditingController,
        autocorrect: false,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () => onPressed!(),
            child: Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          hintText: description,
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
