import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:elevate/backend/domains/authentication/authentication_gateway.dart';

class MaintenanceGateway extends StatelessWidget {
  const MaintenanceGateway({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    return FutureBuilder<DocumentSnapshot>(
      future: firebaseFirestore.collection('application').doc('settings').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return const Center(
            child: SizedBox(
              height: 64,
              width: 64,
              child: CircularProgressIndicator(),
            ),
          );
        }
        final data = snapshot.data?.data() as Map;
        final onMaintenance = data['maintenance'] ?? {};

        if (onMaintenance) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/AppIcon.png",
                width: 64,
                height: 64,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Elevate is currently under maintenance!",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          );
        }

        return const AuthenticationGateway();
      },
    );
  }
}
