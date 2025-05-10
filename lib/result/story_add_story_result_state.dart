
import 'package:story_app/data/api/response/add_story_response.dart';

sealed class StoryAddStoryResultState {}

class StoryAddStoryNoneState extends StoryAddStoryResultState {}

class StoryAddStoryResultStateLoading extends StoryAddStoryResultState {}

class StoryAddStoryResultStateSuccess extends StoryAddStoryResultState {
  final AddStoryResponse addStoryResponse;

  StoryAddStoryResultStateSuccess(this.addStoryResponse);
}

class StoryAddStoryResultStateError extends StoryAddStoryResultState {
  final String error;

  StoryAddStoryResultStateError(this.error);
}