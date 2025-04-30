
import 'package:story_app/data/api/response/login_response.dart';

sealed class StoryLoginResultState {}

class StoryLoginNoneState extends StoryLoginResultState{}

class StoryLoginLoadingState extends StoryLoginResultState{}

class StoryLoginSuccessState extends StoryLoginResultState{
  final LoginResponse loginResponse;

  StoryLoginSuccessState(this.loginResponse);
}

class StoryLoginErrorState extends StoryLoginResultState{
  final String error;
  StoryLoginErrorState(this.error);
}