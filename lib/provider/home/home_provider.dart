import 'package:flutter/material.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/result/story_stories_result_state.dart';

class HomeProvider extends  ChangeNotifier {

  final StoryRepository storyRepository;

  HomeProvider(this.storyRepository);

  StoryStoriesResultState _state = StoryStoriesNoneState();
  StoryStoriesResultState get state => _state;

  Future<void> getStories() async {
    _state = StoryStoriesLoadingState();
    notifyListeners();

    try {
      final storiesResponse = await storyRepository.getAllStories();
      _state = StoryStoriesSuccessState(storiesResponse);
    } catch (e) {
      _state = StoryStoriesErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

}