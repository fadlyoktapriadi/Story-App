import 'package:flutter/material.dart';
import 'package:story_app/data/AuthRepository.dart';
import 'package:story_app/screen/add/add_story_screen.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/home/home_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  final GlobalKey<NavigatorState> _navigatorKey;

  bool registerSelected = false;
  final AuthRepository authRepository;
  List<Page> pages = [];
  bool? isLogin;
  bool? isRegister = false;
  String? selectedStory;
  bool? isAddStory = false;


  MyRouterDelegate(this.authRepository) :
        _navigatorKey = GlobalKey<NavigatorState>(){
    _init();
  }

  _init() async {
    isLogin = await authRepository.getLogin();
    debugPrint("Login status: $isLogin");
    debugPrint("Register status: $isRegister");
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == null) {
      pages = _loggedOutStack;
    } else if (isLogin == true) {
      pages = _loggedInStack;
    } else {
      pages = _loggedOutStack;
    }
    return Navigator(
      key: _navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        if (page.key == const ValueKey("RegisterPage")) {
          isRegister = false;
          notifyListeners();
        }
        if (page.key == ValueKey(selectedStory)) {
          selectedStory = null;
          notifyListeners();
        }
        if (page.key == const ValueKey("AddStoryPage")) {
          isAddStory = false;
          notifyListeners();
        }
      },
    );
  }

  List<Page> get _splashStack => const [
    MaterialPage(
      key: ValueKey("SplashPage"),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        toLogin: () {
          isLogin = true;
          notifyListeners();
        },
        toRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          toLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("HomePage"),
      child: HomeScreen(
        onTap: (String storyId) {
          selectedStory = storyId;
          notifyListeners();
        },
        onLogout: () {
          isLogin = false;
          notifyListeners();
        },
        onAddStory: () {
          isAddStory = true;
          notifyListeners();
        },
      ),
    ),
    if (selectedStory != null)
      MaterialPage(
        key: ValueKey(selectedStory),
        child: DetailScreen(
          id: selectedStory!,
          onBack: () {
            selectedStory = null;
            notifyListeners();
          },
        ),
      ),
    if (isAddStory == true)
      MaterialPage(
        key: const ValueKey("AddStoryPage"),
        child: AddStoryScreen(
          onBack: () {
            isAddStory = false;
            notifyListeners();
          },
        ),
      ),

  ];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;


  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }


}