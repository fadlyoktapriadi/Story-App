import 'package:flutter/material.dart';
import 'package:story_app/data/AuthRepository.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/result/story_login_result_state.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  AuthProvider(this.apiService, this.authRepository);

  StoryLoginResultState _state = StoryLoginNoneState();

  StoryLoginResultState get state => _state;

  bool isLoadingLogin = false;
  bool isLoadingRegister = false;
  bool isLoadingLogout = false;
  bool isLoggedIn = false;

  String message = "";

  Future<void> login(String email, String password) async {
    _state = StoryLoginLoadingState();
    notifyListeners();
    try {
      final loginResponse = await apiService.login(email, password);

      if (loginResponse.message == "success") {
        _state = StoryLoginSuccessState(loginResponse);
        isLoggedIn = true;
        await authRepository.setLogin();
        await authRepository.setToken(loginResponse.loginResult.token);
        debugPrint('Login Success: ${loginResponse.loginResult.token}');
        notifyListeners();
      } else if (loginResponse.message == "error") {
        _state = StoryLoginSuccessState(loginResponse);
        notifyListeners();
        return;
      } else {
        _state = StoryLoginErrorState(loginResponse.message);
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      _state = StoryLoginErrorState(e.toString());
      notifyListeners();
    }
  }

  // Future<void> getLogin() async {
  //   try {
  //     _loginSession = await authRepository.getLogin();
  //     debugPrint('Login Session: $_loginSession');
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  //   notifyListeners();
  // }
}
