
import 'package:story_app/data/api/response/story_response.dart';

sealed class StoryStoriesResultState {}

class StoryStoriesNoneState extends StoryStoriesResultState{}

class StoryStoriesLoadingState extends StoryStoriesResultState{}

class StoryStoriesSuccessState extends StoryStoriesResultState{
  final StoryResponse stories;

  StoryStoriesSuccessState(this.stories);
}

class StoryStoriesErrorState extends StoryStoriesResultState{
  final String error;
  StoryStoriesErrorState(this.error);
}