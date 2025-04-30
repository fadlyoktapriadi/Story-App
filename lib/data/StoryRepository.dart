
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/response/login_response.dart';
import 'package:story_app/data/api/response/register_response.dart';
import 'package:story_app/data/local/preferences/shared_preference_service.dart';

import 'api/api_service.dart';
import 'model/login_model.dart';

class StoryRepository {
  final ApiService apiService;
  final SharedPreferenceService sharedPreferenceService;

  StoryRepository(this.apiService, this.sharedPreferenceService);

  Future<RegisterResponse> register(String name, String email, String password) async {
    try {
      return await apiService.register(name, email, password);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      return await apiService.login(email, password);
    } catch (e) {
      throw Exception('Failed to Login: $e');
    }
  }

  Future<void> setLogin(Login login) async {
    try {
      await sharedPreferenceService.setLogin(login);
    } catch (e) {
      throw Exception('Failed to set login data: $e');
    }
  }

  Future<Login> getLogin() async {
    try {
      return await sharedPreferenceService.getLogin();
    } catch (e) {
      throw Exception('Failed to get login data: $e');
    }
  }




}