import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/AuthRepository.dart';
import 'package:story_app/data/api/response/add_story_response.dart';
import 'package:story_app/data/api/response/login_response.dart';
import 'package:story_app/data/api/response/register_response.dart';
import 'package:story_app/data/api/response/story_detail_response.dart';
import 'package:story_app/data/api/response/story_response.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';

  final AuthRepository authRepository = AuthRepository();

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to Login');
      }
    } catch (e) {
      throw Exception('Failed to Login: ${e.toString()}');
    }
  }

  Future<StoryResponse> getAllStories() async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stories'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return StoryResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      throw Exception('Failed to load stories catch: $e');
    }
  }

  Future<StoryDetailResponse> getStoryDetail(String id) async {
    final token = await authRepository.getToken();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/stories/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return StoryDetailResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load story detail');
      }
    } catch (e) {
      throw Exception('Failed to load story detail catch: $e');
    }
  }

  Future<AddStoryResponse> uploadStory(
    List<int> bytes,
    String fileName,
    String description, {
    double? lat,
    double? lon,
  }) async {
    final token = await authRepository.getToken();

    const String url = "$_baseUrl/stories";

    final uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
      "lat": lat.toString(),
      "lon": lon.toString(),
    };

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201 || statusCode == 200) {
      final AddStoryResponse addStoryResponse = AddStoryResponse.fromJson(
        jsonDecode(responseData),
      );
      return addStoryResponse;
    } else {
      final errorResponse = AddStoryResponse.fromJson(jsonDecode(responseData));
      throw Exception(errorResponse.message ?? "Upload file error");
    }
  }
}
