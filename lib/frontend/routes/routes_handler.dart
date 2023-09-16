import 'package:flutter/material.dart';

import 'package:elevate/frontend/routes/chats/chats.dart';
import 'package:elevate/frontend/routes/friends/friends.dart';
import 'package:elevate/frontend/routes/profile/profile.dart';

class RouteHandler extends StatefulWidget {
  const RouteHandler({super.key});

  @override
  State<RouteHandler> createState() => RouteHandlerState();
}

class RouteHandlerState extends State<RouteHandler> {
  int _selectedRoute = 1;

  PageController pageController = PageController(initialPage: 1);

  final Map<String, Widget> _routes = {
    "Friends": const Friends(),
    "Chats": const Chats(),
    "Profile": const Profile(),
  };

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color backgroundColor = Theme.of(context).colorScheme.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/AppIcon.png",
          width: 32,
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: PageView(
        controller: pageController,
        children: _routes.values.toList(),
        onPageChanged: (index) => setState(() => _selectedRoute = index),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: NavigationBar(
            backgroundColor: secondaryColor,
            indicatorColor: primaryColor,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            selectedIndex: _selectedRoute,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.group),
                label: "Friends",
              ),
              NavigationDestination(
                icon: Icon(Icons.forum),
                label: "Chats",
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
            onDestinationSelected: (index) => setState(
              () {
                _selectedRoute = index;
                pageController.animateToPage(
                  _selectedRoute,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
