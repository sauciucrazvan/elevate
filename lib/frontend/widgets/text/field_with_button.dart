import 'package:flutter/material.dart';

class ButtonedField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String description;
  final bool obscureText;
  final bool withDivider;
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
    this.withDivider = true,
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
      child: Stack(
        children: [
          TextField(
            controller: textEditingController,
            autocorrect: false,
            obscureText: obscureText,
            maxLength: maxLength,
            maxLines: maxLines,
            decoration: InputDecoration(
              suffixIcon: (!withDivider)
                  ? GestureDetector(
                      onTap: () => onPressed!(),
                      child: Icon(
                        icon,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : null,
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
          if (withDivider)
            Positioned(
              right: 0,
              top: 16.0 * maxLines,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  Container(
                    height: 30,
                    width: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onPressed!(),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
