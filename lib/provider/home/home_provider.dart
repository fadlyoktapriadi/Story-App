import 'package:flutter/material.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/result/story_stories_result_state.dart';

class HomeProvider extends ChangeNotifier {
  final StoryRepository storyRepository;

  HomeProvider(this.storyRepository);

  StoryStoriesResultState _state = StoryStoriesNoneState();

  StoryStoriesResultState get state => _state;

  final List _stories = [];

  List get stories => List.unmodifiable(_stories);

  int pageItems = 1;
  int sizeItems = 10;
  bool hasMorePages = true;
  bool _isFetching = false;
  bool _isInitialLoad = true;

  bool get isLoadingMore => _isFetching && !_isInitialLoad;

  Future<void> getStories({bool refresh = false, int? location}) async {
    if (_isFetching) return;
    if (!hasMorePages && !refresh) return;

    if (refresh) {
      pageItems = 1;
      hasMorePages = true;
      _stories.clear();
      _isInitialLoad = true;
    }

    _isFetching = true;
    if (_isInitialLoad) {
      _state = StoryStoriesLoadingState();
      notifyListeners();
    }

    try {
      final storiesResponse = await storyRepository.getAllStories(
        page: pageItems,
        size: sizeItems,
        location: location,
      );

      final newStories = storiesResponse.listStory ?? [];
      _stories.addAll(newStories);

      hasMorePages = newStories.length == sizeItems;
      if (hasMorePages) pageItems += 1;

      _state = StoryStoriesSuccessState(storiesResponse);
      _isInitialLoad = false;
    } catch (e) {
      _state = StoryStoriesErrorState(e.toString());
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
