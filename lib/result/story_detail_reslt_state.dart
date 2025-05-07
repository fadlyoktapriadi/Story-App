import 'package:story_app/data/api/response/story_detail_response.dart';

sealed class StoryDetailResultState {}

class StoryDetailNoneState extends StoryDetailResultState{}

class StoryDetailLoadingState extends StoryDetailResultState{}

class StoryDetailSuccessState extends StoryDetailResultState{
  final StoryDetailResponse story;

  StoryDetailSuccessState(this.story);
}

class StoryDetailErrorState extends StoryDetailResultState{
  final String error;
  StoryDetailErrorState(this.error);
}