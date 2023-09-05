import 'package:elevate/frontend/widgets/buttons/long_button/long_button.dart';
import 'package:elevate/frontend/widgets/marginals/header.dart';
import 'package:elevate/frontend/widgets/text/field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailTextController = TextEditingController();
    TextEditingController passwordTextController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Header(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animation
          Lottie.asset("assets/animations/login.json", width: 128, height: 128),

          // Title
          Text(
            "Welcome back to Elevate!\nYou've been missed!",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: const Divider(),
          ),

          // Email Text Field
          Field(
            textEditingController: emailTextController,
            description: 'Email',
          ),

          const SizedBox(
            height: 8,
          ),

          // Password Text Field
          Field(
            textEditingController: passwordTextController,
            description: 'Password',
            obscureText: true,
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: const Divider(),
          ),

          // Login Button
          LongButton(
            title: "Login",
            icon: Icons.arrow_forward_ios,
            onTap: () {},
          ),

          const SizedBox(
            height: 16,
          ),

          // Go To Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Need an account?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                ),
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                "Let's create one!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
