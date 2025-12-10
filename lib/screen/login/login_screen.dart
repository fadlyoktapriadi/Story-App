import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:story_app/common.dart';
import 'package:story_app/screen/login/form_login.dart';

class LoginScreen extends StatelessWidget {
  final Function() toLogin;
  final Function() toRegister;

  const LoginScreen({
    super.key,
    required this.toLogin,
    required this.toRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                "Storyfy",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/animation/animation_login.json',
                // Replace with your file path
                width: 150, // Optional: Set width
                height: 150, // Optional: Set height
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.loginWelcome,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.smallLoginTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),

              FormLogin(toLogin: toLogin, toRegister: toRegister),
            ],
          ),
        ),
      ),
    );
  }
}
