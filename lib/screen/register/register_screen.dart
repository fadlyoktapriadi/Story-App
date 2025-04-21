import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
            Lottie.asset('assets/animation/animation_register.json', // Replace with your file path
              width: 150, // Optional: Set width
              height: 150, // Optional: Set height
            ),
            const SizedBox(height: 10),
            Text("Create your account and share your story with Storyfy", style: Theme.of(context).textTheme.labelLarge),

            FormRegister()

          ],
        ),
      ),
    ),
    );
  }
}
