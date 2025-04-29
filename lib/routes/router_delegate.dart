import 'package:flutter/material.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  bool registerSelected = false;

  final GlobalKey<NavigatorState> _navigatorKey;
  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            toRegister: () {
              registerSelected = true;
              notifyListeners();
            },
          ),
        ),
        if (registerSelected)
          MaterialPage(
              key: ValueKey("RegisterPage"),
              child: RegisterScreen(
                toLogin: () {
                  registerSelected = false;
                  notifyListeners();
                },
              )
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == ValueKey("RegisterPage")) {
          // Hapus fungsi setState dan ubah dengan method notifyListeners()
          registerSelected = false;
          notifyListeners();
        }
      },
    );
  }



  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

}