import 'package:flutter/material.dart';

class Toggable extends StatefulWidget {
  final String title;
  final Widget child;
  final bool opened;

  const Toggable({
    super.key,
    required this.title,
    required this.child,
    this.opened = false,
  });

  @override
  State<Toggable> createState() => _ToggableState();
}

class _ToggableState extends State<Toggable> {
  bool opened = false;

  @override
  void initState() {
    opened = widget.opened;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                onPressed: () => setState(() => opened = !opened),
                child: opened
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        color: textColor,
                      )
                    : Icon(
                        Icons.keyboard_arrow_left,
                        color: textColor,
                      ),
              ),
            ],
          ),
          if (opened) widget.child
        ],
      ),
    );
  }
}
