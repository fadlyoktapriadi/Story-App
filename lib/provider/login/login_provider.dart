
import 'package:flutter/material.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/result/story_login_result_state.dart';

class LoginProvider extends ChangeNotifier {

  final StoryRepository storyRepository;

  LoginProvider(this.storyRepository);

  StoryLoginResultState _state = StoryLoginNoneState();
  StoryLoginResultState get state => _state;

  Future<void> login(String email, String password) async {
    _state = StoryLoginLoadingState();
    notifyListeners();

    try {
      final loginResponse = await storyRepository.login(email, password);
      debugPrint('Berhasil: ${loginResponse.toJson()}');
      _state = StoryLoginSuccessState(loginResponse);
    } catch (e) {
      debugPrint('Error: $e');
      _state = StoryLoginErrorState(e.toString());
    }
    notifyListeners();
  }

  Future<void> setLogin(Login login) async {
    try {
      await storyRepository.setLogin(login);
    } catch (e) {
      debugPrint('Error: $e');
    }
    notifyListeners();
  }

  Future<Login> getLogin() async {
    try {
      return await storyRepository.getLogin();
    } catch (e) {
      debugPrint('Error: $e');
    }
    notifyListeners();
  }

}