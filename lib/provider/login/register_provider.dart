
import 'package:flutter/material.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/result/story_register_result_state.dart';

class RegisterProvider with ChangeNotifier {

  final StoryRepository storyRepository;

  RegisterProvider(this.storyRepository);

  StoryRegisterResultState _state = StoryRegisterNoneState();
  StoryRegisterResultState get state => _state;

  Future<void> register(String name, String email, String password) async {
    _state = StoryRegisterLoadingState();
    notifyListeners();

    try {
      final registerResponse = await storyRepository.register(name, email, password);
      _state = StoryRegisterSuccessState(registerResponse);
    } catch (e) {
      _state = StoryRegisterErrorState(e.toString());
    }

    notifyListeners();
  }



}