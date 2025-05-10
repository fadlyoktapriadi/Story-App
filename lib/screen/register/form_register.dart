import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common.dart';
import 'package:story_app/provider/register/register_provider.dart';
import 'package:story_app/result/story_register_result_state.dart';

class FormRegister extends StatefulWidget {
  final Function() toLogin;

  const FormRegister({super.key, required this.toLogin});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 5),
                  TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.placeholderName,
                    prefixIcon: Icon(Icons.person_outline),
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
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("E-Mail", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.placeholderEmail,
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
                Text("Password", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.placeholderPassword,
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
                backgroundColor:
                    Theme.of(context).colorScheme.primary, // Primary color
                foregroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.onPrimary, // Text color on primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await provider.register(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (provider.state is StoryRegisterSuccessState) {
                      final state =
                          (provider.state as StoryRegisterSuccessState)
                              .registerResponse;

                      if (state.error) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Register Success: ${state.message}"),
                          ),
                        );
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        await Future.delayed(const Duration(seconds: 1));
                        widget.toLogin();
                      }
                    } else if (provider.state is StoryRegisterErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration failed!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to register: $e')),
                    );
                  }
                }
              },
              child: Consumer<RegisterProvider>(
                builder: (context, value, child) {
                  return switch (value.state) {
                    StoryRegisterLoadingState() => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    StoryRegisterSuccessState() => Text(
                      AppLocalizations.of(context)!.registerButton,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    _ => Text(
                      AppLocalizations.of(context)!.registerButton,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  };
                },
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                widget.toLogin();
              },
              child: Text(
                AppLocalizations.of(context)!.alreadyHaveAccount,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
