import 'package:flutter/material.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/styles/theme/story_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: LoginScreen()
    );
  }
}
