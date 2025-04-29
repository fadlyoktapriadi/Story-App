
import 'package:story_app/data/api/response/register_response.dart';

sealed class StoryRegisterResultState {}


class StoryRegisterNoneState extends StoryRegisterResultState{}

class StoryRegisterLoadingState extends StoryRegisterResultState{}

class StoryRegisterSuccessState extends StoryRegisterResultState{
  final RegisterResponse registerResponse;

  StoryRegisterSuccessState(this.registerResponse);
}

class StoryRegisterErrorState extends StoryRegisterResultState{
  final String error;
  StoryRegisterErrorState(this.error);
}