import 'api/api_service.dart';
import 'api/response/add_story_response.dart';
import 'api/response/story_detail_response.dart';
import 'api/response/story_response.dart';

class StoryRepository {
  final ApiService apiService;

  StoryRepository(this.apiService);

  Future<StoryResponse> getAllStories({int? page, int? size, int? location}) {
    return apiService.getAllStories(page: page, size: size, location: location);
  }

  Future<StoryDetailResponse> getStoryDetail(String id) {
    return apiService.getStoryDetail(id);
  }

  Future<AddStoryResponse> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lon,
  ) {
    return apiService.uploadStory(
      bytes,
      fileName,
      description,
      lat: lat,
      lon: lon,
    );
  }
}
