
import 'package:story_app/data/api/response/register_response.dart';

import 'api/api_service.dart';

class StoryRepository {
  final ApiService apiService;

  StoryRepository(this.apiService);

  Future<RegisterResponse> register(String name, String email, String password) async {
    try {
      return await apiService.register(name, email, password);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }


}