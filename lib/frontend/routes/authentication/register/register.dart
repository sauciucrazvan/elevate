import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:elevate/frontend/widgets/text/field.dart';
import 'package:elevate/frontend/widgets/marginals/header.dart';
import 'package:elevate/frontend/widgets/buttons/long_button/long_button.dart';

import 'package:elevate/backend/domains/authentication/authentication_service.dart';

class Register extends StatefulWidget {
  final Function switchPages;

  const Register({super.key, required this.switchPages});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();

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
              Lottie.asset("assets/animations/register.json",
                  width: 128, height: 128),

              // Title
              Text(
                "Welcome to Elevate!\nYou'll first need to create an account.",
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
                height: 4,
              ),

              // Password Text Field
              Field(
                textEditingController: passwordTextController,
                description: 'Password',
                obscureText: true,
              ),

              const SizedBox(
                height: 4,
              ),

              // Confirm Password Text Field
              Field(
                textEditingController: confirmPasswordTextController,
                description: 'Confirm password',
                obscureText: true,
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: const Divider(),
              ),

              // Login Button
              LongButton(
                title: "Register",
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  try {
                    AuthenticationService().signUp(
                        emailTextController.text, passwordTextController.text);
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
                    "Already have an account?",
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
                      "Proceed to login.",
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
