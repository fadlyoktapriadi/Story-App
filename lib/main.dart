import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/AuthRepository.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/local/preferences/shared_preference_service.dart';
import 'package:story_app/provider/add/add_provider.dart';
import 'package:story_app/provider/detail/detail_provider.dart';
import 'package:story_app/provider/home/home_provider.dart';
import 'package:story_app/provider/login/auth_provider.dart';
import 'package:story_app/provider/register/register_provider.dart';
import 'package:story_app/routes/router_delegate.dart';
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
  late AuthProvider authProvider;
  late ApiService apiService;
  late AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    apiService = ApiService();
    myRouterDelegate = MyRouterDelegate(authRepository);
    authProvider = AuthProvider(apiService, authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => authProvider
        ),
        ChangeNotifierProvider(
            create: (context) => RegisterProvider(apiService)
        ),
        ChangeNotifierProvider(
            create: (context) => HomeProvider(apiService)
        ),
        ChangeNotifierProvider(
            create: (context) => DetailProvider(apiService)
        ),
        ChangeNotifierProvider(
            create: (context) => AddProvider()
        )
      ],
      child: MaterialApp(
        theme: StoryTheme.lightTheme,
        darkTheme: StoryTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
