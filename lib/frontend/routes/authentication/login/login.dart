import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:elevate/frontend/widgets/text/field.dart';
import 'package:elevate/frontend/widgets/marginals/header.dart';
import 'package:elevate/frontend/widgets/buttons/long_button/long_button.dart';

import 'package:elevate/backend/domains/rate_limit/rate_limit_service.dart';
import 'package:elevate/backend/handlers/authentication/authentication_handler.dart';

class Login extends StatefulWidget {
  final Function switchPages;

  const Login({super.key, required this.switchPages});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Header(context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Animation
              Lottie.asset("assets/animations/login.json",
                  width: 128, height: 128),

              // Title
              Text(
                "Welcome back to Elevate!\nYou have to login into your existing account.",
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

              // Name Text Field
              Field(
                textEditingController: nameTextController,
                description: 'Username',
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
                onTap: () {
                  if (!RateLimitService().canPerformAction(context)) return;

                  try {
                    loginUser(context, nameTextController.text,
                        passwordTextController.text);
                  } catch (error) {
                    throw Exception(error);
                  }
                },
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
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  GestureDetector(
                    onTap: () => widget.switchPages(),
                    child: Text(
                      "Let's create one!",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
