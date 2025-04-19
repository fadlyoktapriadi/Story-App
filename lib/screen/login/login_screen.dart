
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Storyfy",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              )),
              const SizedBox(height: 20),
              Text("Welcome to Storyfy", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text("Sign up or login bellow to share your story", style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 20),
        
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: Theme.of(context).colorScheme.surface,
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: Theme.of(context).colorScheme.surface,
                          filled: true,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // Full-width button
                          backgroundColor: Theme.of(context).colorScheme.primary, // Primary color
                          foregroundColor: Theme.of(context).colorScheme.onPrimary, // Text color on primary
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Login",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text("Don't have an account? Sign up",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                      ),
                    ],
                  ),
                ),
              )
        
        
            ],
          ),
        ),
      ),
    );
  }
}
