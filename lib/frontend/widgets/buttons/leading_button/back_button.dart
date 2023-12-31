// Imported from Tracely (https://github.com/sauciucrazvan/tracely)
import 'package:flutter/material.dart';

class BackLeadingButton extends StatelessWidget {
  const BackLeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            size: 16,
          ),
        ),
      ),
    );
  }
}
