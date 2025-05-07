
import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/result/story_detail_reslt_state.dart';

class DetailProvider with ChangeNotifier {
  final ApiService apiService;

  DetailProvider(this.apiService);

  StoryDetailResultState _state = StoryDetailNoneState();
  StoryDetailResultState get state => _state;

  Future<void> getDetailStory(String id) async {
    _state = StoryDetailLoadingState();
    notifyListeners();

    try {
      final detailResponse = await apiService.getStoryDetail(id);
      _state = StoryDetailSuccessState(detailResponse);
    } catch (e) {
      _state = StoryDetailErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }


}