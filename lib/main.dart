import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/login/register_provider.dart';
import 'package:story_app/routes/router_delegate.dart';import 'package:flutter/services.dart';
import 'package:story_app/styles/theme/story_theme.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => MyRouterDelegate()
      ),
      ChangeNotifierProvider(create: (context) => RegisterProvider(StoryRepository(ApiService()))
      )

    ],
      child: const MainApp(),
    )
  );
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