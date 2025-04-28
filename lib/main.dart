import 'package:flutter/material.dart';
import 'package:story_app/routes/router_delegate.dart';import 'package:flutter/services.dart';
import 'package:story_app/styles/theme/story_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Router(routerDelegate: myRouterDelegate, backButtonDispatcher: RootBackButtonDispatcher()),
    );
  }
}
