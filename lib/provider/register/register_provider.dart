
import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/result/story_register_result_state.dart';

class RegisterProvider with ChangeNotifier {

  final ApiService apiService;

  RegisterProvider(this.apiService);

  StoryRegisterResultState _state = StoryRegisterNoneState();
  StoryRegisterResultState get state => _state;

  Future<void> register(String name, String email, String password) async {
    _state = StoryRegisterLoadingState();
    notifyListeners();

    try {
      final registerResponse = await apiService.register(name, email, password);
      _state = StoryRegisterSuccessState(registerResponse);
    } catch (e) {
      _state = StoryRegisterErrorState(e.toString());
    }
    notifyListeners();
  }
}