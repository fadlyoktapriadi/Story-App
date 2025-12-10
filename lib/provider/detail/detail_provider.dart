import 'package:flutter/material.dart';
import 'package:story_app/data/StoryRepository.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/result/story_detail_result_state.dart';

class DetailProvider with ChangeNotifier {

  final StoryRepository storyRepository;

  DetailProvider(this.storyRepository);

  StoryDetailResultState _state = StoryDetailNoneState();
  StoryDetailResultState get state => _state;

  Future<void> getDetailStory(String id) async {
    _state = StoryDetailLoadingState();
    notifyListeners();

    try {
      final detailResponse = await storyRepository.getStoryDetail(id);
      _state = StoryDetailSuccessState(detailResponse);
    } catch (e) {
      _state = StoryDetailErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }


}