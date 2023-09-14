import 'package:flutter/material.dart';

import 'package:elevate/backend/domains/pictures/avatar_service.dart';

class Avatar extends StatelessWidget {
  final String username;
  final double size;

  const Avatar({
    super.key,
    required this.username,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      radius: size,
      child: FutureBuilder<String?>(
        future: AvatarService().getAvatar(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              snapshot.data == null) {
            return Image.asset('assets/images/AppIcon.png');
          }

          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(snapshot.data!),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
