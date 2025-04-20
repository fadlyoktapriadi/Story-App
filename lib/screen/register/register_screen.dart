import 'package:flutter/material.dart';
import 'package:story_app/screen/register/form_register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text("Storyfy",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
            const SizedBox(height: 20),
            Text("Sign up your account in form below", style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 20),

            RegisterLogin()

          ],
        ),
      ),
    ),
    );
  }
}
