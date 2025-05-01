import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/login/auth_provider.dart';
import 'package:story_app/result/story_login_result_state.dart';

class FormLogin extends StatefulWidget {
  final Function() toLogin;
  final Function() toRegister;

  const FormLogin({super.key, required this.toLogin, required this.toRegister});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E-Mail",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Full-width button
                backgroundColor: Theme.of(context).colorScheme.primary, // Primary color
                foregroundColor: Theme.of(context).colorScheme.onPrimary, // Text color on primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.login(_emailController.text, _passwordController.text);
                  authProvider.addListener(() {
                    if (authProvider.state is StoryLoginLoadingState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Loading...")),
                      );
                    } else if (authProvider.state is StoryLoginSuccessState) {
                      widget.toLogin();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Success")),
                      );
                    } else if (authProvider.state is StoryLoginErrorState) {
                      final errorMessage = (authProvider.state as StoryLoginErrorState).error;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                  });
                }
              },
              child: Consumer<AuthProvider>(
                builder: (context, value, child) {
                  return switch (value.state) {
                    StoryLoginLoadingState() => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    StoryLoginSuccessState() => Text(
                      "Sign In",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    _ => Text(
                      "Sign In",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  };
                },
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Full-width button
                backgroundColor: Theme.of(context).colorScheme.surface, // Primary color
                foregroundColor: Theme.of(context).colorScheme.onSurface, // Text color on primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              onPressed: () {
                widget.toRegister();
              },
              child: Text("Sign Up",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}